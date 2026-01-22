const CACHE_NAME = 'livre-io-v3';
const ASSETS_TO_CACHE = [
    './',
    './index.html',
    './styles.css',
    './app.js',
    './icon.png',
    './manifest.json'
];

// ==================== NOTIFICAÇÕES PROGRAMADAS ====================

// Mensagens motivacionais para diferentes horários
const MOTIVATIONAL_MESSAGES = {
    morning: [
        { title: '🌅 Bom dia, campeão!', body: 'Mais um dia de vitória começa agora. Você está mais forte que ontem!' },
        { title: '☀️ Novo dia, nova força!', body: 'Cada manhã sem cigarro é uma conquista. Continue assim!' },
        { title: '💪 Amanheceu livre!', body: 'Seu corpo agradece. Respire fundo e sinta a diferença.' }
    ],
    afternoon: [
        { title: '🎯 Metade do dia conquistada!', body: 'Sentiu vontade? Faça um exercício de respiração agora.' },
        { title: '⚡ Mantenha o foco!', body: 'A vontade passa em 5 minutos. Você consegue!' },
        { title: '🏆 Você está arrasando!', body: 'Continue firme. Cada hora conta.' }
    ],
    evening: [
        { title: '🌙 Boa noite, guerreiro!', body: 'Mais um dia livre! Amanhã será ainda melhor.' },
        { title: '✨ Parabéns pelo dia de hoje!', body: 'Você venceu mais um dia. Descanse bem.' },
        { title: '🌟 Dia de vitória!', body: 'Durma tranquilo sabendo que fez a escolha certa.' }
    ],
    craving: [
        { title: '🚨 Sentindo vontade?', body: 'Abra o app e faça um exercício de respiração. Vai passar!' },
        { title: '💪 Você é mais forte!', body: 'A vontade dura apenas 5 minutos. Aguente firme!' },
        { title: '🧘 Respire fundo...', body: 'Inspire 4s, segure 7s, expire 8s. Você consegue!' }
    ]
};

// Função para selecionar mensagem aleatória
function getRandomMessage(timeOfDay) {
    const messages = MOTIVATIONAL_MESSAGES[timeOfDay] || MOTIVATIONAL_MESSAGES.morning;
    return messages[Math.floor(Math.random() * messages.length)];
}

// ==================== PUSH NOTIFICATIONS ====================

// Receber notificação push do servidor (para futuro backend)
self.addEventListener('push', (event) => {
    let data = { title: '🍃 Livre.io', body: 'Você tem uma nova mensagem!' };

    if (event.data) {
        try {
            data = event.data.json();
        } catch (e) {
            data.body = event.data.text();
        }
    }

    const options = {
        body: data.body,
        icon: './icon.png',
        badge: './icon.png',
        vibrate: [100, 50, 100],
        data: {
            dateOfArrival: Date.now(),
            url: data.url || './'
        },
        actions: [
            { action: 'open', title: '📱 Abrir App' },
            { action: 'dismiss', title: '✖️ Fechar' }
        ],
        requireInteraction: false,
        tag: 'livre-io-notification'
    };

    event.waitUntil(
        self.registration.showNotification(data.title, options)
    );
});

// Clique na notificação
self.addEventListener('notificationclick', (event) => {
    event.notification.close();

    if (event.action === 'dismiss') {
        return;
    }

    // Abrir ou focar no app
    event.waitUntil(
        clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
            // Se já tiver uma janela aberta, focar nela
            for (const client of clientList) {
                if ('focus' in client) {
                    return client.focus();
                }
            }
            // Senão, abrir nova janela
            if (clients.openWindow) {
                return clients.openWindow(event.notification.data.url || './');
            }
        })
    );
});

// ==================== SCHEDULED NOTIFICATIONS (via messages) ====================

// Receber mensagem do main thread para agendar notificação
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SCHEDULE_NOTIFICATION') {
        const { delay, timeOfDay } = event.data;

        setTimeout(() => {
            const message = getRandomMessage(timeOfDay || 'morning');
            self.registration.showNotification(message.title, {
                body: message.body,
                icon: './icon.png',
                badge: './icon.png',
                vibrate: [100, 50, 100],
                tag: 'livre-io-scheduled',
                requireInteraction: false,
                actions: [
                    { action: 'open', title: '📱 Abrir App' }
                ]
            });
        }, delay);
    }

    if (event.data && event.data.type === 'SHOW_NOTIFICATION_NOW') {
        const { title, body } = event.data;
        self.registration.showNotification(title || '🍃 Livre.io', {
            body: body || 'Hora de cuidar de você!',
            icon: './icon.png',
            badge: './icon.png',
            vibrate: [100, 50, 100],
            tag: 'livre-io-instant',
            requireInteraction: false
        });
    }
});

// ==================== CACHE ====================

// Install Event - Cache Files
self.addEventListener('install', (event) => {
    self.skipWaiting(); // Ativar imediatamente
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then((cache) => {
                // Cache apenas arquivos locais, ignorar erros
                return Promise.allSettled(
                    ASSETS_TO_CACHE.map(url =>
                        cache.add(url).catch(err => {
                            console.warn(`Falha ao cachear ${url}:`, err);
                        })
                    )
                );
            })
    );
});

// Fetch Event - Network first, then cache
self.addEventListener('fetch', (event) => {
    // Ignorar requisições não-GET e externas
    if (event.request.method !== 'GET') return;

    // Ignorar URLs externas (CDNs, APIs, etc)
    const url = new URL(event.request.url);
    if (url.origin !== location.origin) {
        return;
    }

    event.respondWith(
        fetch(event.request)
            .then((response) => {
                // Cachear resposta válida
                if (response && response.status === 200) {
                    const responseClone = response.clone();
                    caches.open(CACHE_NAME).then((cache) => {
                        cache.put(event.request, responseClone);
                    });
                }
                return response;
            })
            .catch(() => {
                // Fallback para cache se offline
                return caches.match(event.request);
            })
    );
});

// Activate Event - Cleanup Old Caches
self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((keyList) => {
            return Promise.all(keyList.map((key) => {
                if (key !== CACHE_NAME) {
                    return caches.delete(key);
                }
            }));
        })
    );
    // Tomar controle de todas as páginas imediatamente
    return self.clients.claim();
});
