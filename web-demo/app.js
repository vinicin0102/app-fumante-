const state = {
    cigsPerDay: 15,
    yearsSmoking: 5,
    packPrice: 10.0,
    quitDate: null,
    messages: [],
    missions: [
        { id: 1, title: 'Registrar humor no diário', completed: false },
        { id: 2, title: 'Fazer 1 exercício de respiração', completed: false },
        { id: 3, title: 'Ler uma dica de saúde', completed: false },
        { id: 4, title: 'Beber um copo d\'água', completed: false }
    ]
};

// ==================== ONBOARDING ====================
function checkFirstAccess() {
    const savedData = localStorage.getItem('quitnow_user');
    if (savedData) {
        const data = JSON.parse(savedData);
        state.cigsPerDay = data.cigsPerDay;
        state.packPrice = data.packPrice;
        state.quitDate = new Date(data.quitDate);
        document.getElementById('onboardingWizard').classList.add('onboarding-hidden');
        startApp();
    } else {
        document.getElementById('onboardingWizard').classList.remove('onboarding-hidden');
    }
}

function nextStep(step) {
    document.querySelectorAll('.step-content').forEach(el => el.classList.remove('active'));
    document.querySelector(`.step-content[data-step="${step}"]`).classList.add('active');

    // Update progress bar and labels
    const percent = Math.round((step / 6) * 100);
    document.getElementById('progressBar').style.width = `${percent}%`;
    document.getElementById('stepLabel').textContent = `Passo ${step} de 6`;
    document.getElementById('stepPercent').textContent = `${percent}%`;

    // Calculate diagnostics when reaching step 4
    if (step === 4) {
        const totalCigs = state.cigsPerDay * 365 * state.yearsSmoking;
        const timeLostMinutes = totalCigs * 11; // 11 min per cig
        const timeLostDays = Math.round(timeLostMinutes / 60 / 24);
        const moneySpent = (state.cigsPerDay / 20) * state.packPrice * 365 * state.yearsSmoking;

        document.getElementById('diagCigs').textContent = totalCigs.toLocaleString('pt-BR');
        document.getElementById('diagTime').textContent = `~${timeLostDays} dias`;
        document.getElementById('diagMoney').textContent = `R$ ${moneySpent.toLocaleString('pt-BR', { maximumFractionDigits: 0 })}`;
    }
}

function updateOnboardingData(type, value) {
    if (type === 'cigs') {
        state.cigsPerDay = parseInt(value);
        document.getElementById('cigDisplay').textContent = value;
    }
    if (type === 'years') {
        state.yearsSmoking = parseInt(value);
        document.getElementById('yearsDisplay').textContent = value;
    }
    if (type === 'price') {
        state.packPrice = parseFloat(value);
        document.getElementById('priceDisplay').textContent = `R$ ${parseInt(value)}`;
    }

    // Atualizar estimativa mensal e anual
    if (document.getElementById('monthlySpendDisplay')) {
        const monthly = (state.cigsPerDay / 20) * state.packPrice * 30;
        const yearly = monthly * 12;
        document.getElementById('monthlySpendDisplay').textContent = `R$ ${Math.round(monthly)}/mês`;
        if (document.getElementById('yearlySpendDisplay')) {
            document.getElementById('yearlySpendDisplay').textContent = `R$ ${yearly.toLocaleString('pt-BR', { maximumFractionDigits: 0 })}`;
        }
    }
}

function finishOnboarding() {
    state.quitDate = new Date();
    state.quitDate.setHours(state.quitDate.getHours() - 1); // Simular 1h pra dar graça
    localStorage.setItem('quitnow_user', JSON.stringify({
        cigsPerDay: state.cigsPerDay,
        yearsSmoking: state.yearsSmoking,
        packPrice: state.packPrice,
        quitDate: state.quitDate.toISOString()
    }));
    document.getElementById('onboardingWizard').classList.add('onboarding-hidden');
    startApp();
}

// ==================== MAIN APP ====================
function startApp() {
    updateTimer();
    updateProfileSettings();
    checkDailyMissions(); // Verificar/Carregar missões
    renderMissions();
    setInterval(updateTimer, 1000);
    initChat();
    initMoodSelector();
    updatePromoCards(); // Atualizar estado dos cards promocionais
}

// ==================== JOURNAL ====================
function initMoodSelector() {
    const moods = document.querySelectorAll('.mood-btn');
    moods.forEach(btn => {
        btn.onclick = function () {
            moods.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        }
    });
}

// ==================== DAILY MISSIONS ====================
function checkDailyMissions() {
    const today = new Date().toDateString();
    const savedMissions = localStorage.getItem('quitnow_missions');
    const lastDate = localStorage.getItem('quitnow_missions_date');

    if (savedMissions && lastDate === today) {
        state.missions = JSON.parse(savedMissions);
    } else {
        // Resetar missões se for um novo dia
        state.missions.forEach(m => m.completed = false);
        localStorage.setItem('quitnow_missions_date', today);
        saveMissions();
    }
}

function renderMissions() {
    const container = document.getElementById('missionList');
    if (!container) return;

    container.innerHTML = '';
    state.missions.forEach(mission => {
        const div = document.createElement('div');
        div.className = `mission-item ${mission.completed ? 'completed' : ''}`;
        div.onclick = () => toggleMission(mission.id);

        div.innerHTML = `
            <div class="mission-checkbox ${mission.completed ? 'checked' : ''}">
                ${mission.completed ? '<span class="material-icons">check</span>' : ''}
            </div>
            <div class="mission-content">
                <span class="mission-title">${mission.title}</span>
            </div>
        `;
        container.appendChild(div);
    });
}

function toggleMission(id) {
    const mission = state.missions.find(m => m.id === id);
    if (mission) {
        mission.completed = !mission.completed;
        saveMissions();
        renderMissions();

        // Efeito visual de confete ou som poderia ser adicionado aqui
        if (mission.completed) {
            // Pequeno feedback tátil/visual (opcional)
        }
    }
}

function saveMissions() {
    localStorage.setItem('quitnow_missions', JSON.stringify(state.missions));
}

function updateTimer() {
    if (!state.quitDate) return;
    const now = new Date();
    const diff = now - state.quitDate;

    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

    document.getElementById('days').textContent = String(days).padStart(2, '0');
    document.getElementById('hours').textContent = String(hours).padStart(2, '0');
    document.getElementById('minutes').textContent = String(minutes).padStart(2, '0');

    // Stats calculation
    const minutesPassed = Math.floor(diff / 60000);
    const cigsAvoided = Math.floor((state.cigsPerDay / 1440) * minutesPassed);
    const moneySaved = (cigsAvoided * (state.packPrice / 20)).toFixed(2);

    document.getElementById('avoidedCigs').textContent = cigsAvoided;
    document.getElementById('moneySaved').textContent = `R$ ${moneySaved.replace('.', ',')}`;
    document.getElementById('lifeSaved').textContent = `${Math.floor(cigsAvoided * 11 / 60)}h`;

    // Update Profile Stats
    if (document.getElementById('profileCigsAvoided')) {
        document.getElementById('profileCigsAvoided').textContent = cigsAvoided;
        document.getElementById('profileMoneySaved').textContent = `R$ ${moneySaved.replace('.', ',')}`;
        document.getElementById('profileLifeSaved').textContent = `${Math.floor(cigsAvoided * 11 / 60)}h`;
        document.getElementById('profileStreak').textContent = `${days} dias`;
    }
}

function updateProfileSettings() {
    if (!document.getElementById('profileCigsPerDay')) return;
    document.getElementById('profileCigsPerDay').textContent = state.cigsPerDay;
    document.getElementById('profilePackPrice').textContent = `R$ ${state.packPrice.toFixed(2).replace('.', ',')}`;
    if (state.quitDate) {
        document.getElementById('profileQuitDate').textContent = state.quitDate.toLocaleDateString('pt-BR');
    }
}

function resetProgress() {
    if (confirm('Tem certeza? Todo o seu progresso será apagado.')) {
        localStorage.removeItem('quitnow_user');
        location.reload();
    }
}

// ==================== CHAT ====================
const fakeMessages = ['Força pessoal!', 'Hoje fez 3 dias 🎉', 'Não desista!'];
function initChat() {
    addMessage('Moderador', 'Bem-vindos ao Chat Global! 🚭', false);
    setInterval(() => {
        if (Math.random() > 0.7) addMessage('João', fakeMessages[Math.floor(Math.random() * 3)], false);
    }, 4000);
}

function addMessage(user, text, isMe) {
    const chat = document.getElementById('chatArea');
    const div = document.createElement('div');
    div.className = `message-bubble ${isMe ? 'message-sent' : 'message-received'}`;
    div.innerHTML = isMe ? text : `<span class="message-sender">${user}</span>${text}`;
    chat.appendChild(div);
    chat.scrollTop = chat.scrollHeight;
}

function sendMessage() {
    const input = document.getElementById('messageInput');
    if (!input.value.trim()) return;
    addMessage('Você', input.value, true);
    input.value = '';
}

// ==================== NAVIGATION ====================
function switchView(viewName, btn) {
    document.querySelectorAll('.app-view').forEach(el => el.classList.remove('active'));
    document.getElementById(`view-${viewName}`).classList.add('active');

    document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
    if (btn) btn.classList.add('active');

    // Show/Hide Emergency Button based on view
    const fab = document.getElementById('emergencyBtn');
    if (viewName === 'home') fab.style.display = 'flex';
    else fab.style.display = 'none';
}

// ==================== MODALS ====================
function showEmergencyModal() { document.getElementById('emergencyModal').classList.add('active'); }
function showExerciseModal() { document.getElementById('exerciseModal').classList.add('active'); }
function showJournalModal() { document.getElementById('journalModal').classList.add('active'); }
function showCognitiveExercise() {
    closeModals();
    setTimeout(() => document.getElementById('cognitiveModal').classList.add('active'), 100);
}
function closeModals() {
    document.querySelectorAll('.modal').forEach(m => m.classList.remove('active'));
    resetBreathing();
}

function showPremiumOffer() {
    closeModals();
    setTimeout(() => document.getElementById('premiumModal').classList.add('active'), 100);
}

function subscribePremium() {
    alert('Redirecionando para o checkout seguro...');
    // Aqui iria o link do Stripe/Hotmart
    closeModals();
}

function showBreathingExercise() {
    closeModals();
    setTimeout(() => document.getElementById('breathingModal').classList.add('active'), 100);
}

// ==================== PROGRAMA DE 3 DIAS ====================

function show3DayProgram() {
    // Criar modal dinamicamente
    const existingModal = document.getElementById('programModal');
    if (existingModal) existingModal.remove();

    const modal = document.createElement('div');
    modal.id = 'programModal';
    modal.className = 'modal active';
    modal.innerHTML = `
        <div class="modal-content" style="max-width: 420px; background: linear-gradient(180deg, #0F172A, #1E293B); color: white;">
            <button class="modal-close" onclick="closeModals()" style="background: rgba(255,255,255,0.1); color: white;"><span class="material-icons">close</span></button>
            
            <div style="text-align: center; margin-bottom: 24px;">
                <span style="font-size: 48px;">🚀</span>
                <h2 style="margin: 12px 0 8px 0;">Programa de 3 Dias</h2>
                <p style="color: #94A3B8; font-size: 14px;">Seu caminho para a liberdade</p>
            </div>

            <div style="margin-bottom: 24px;">
                <!-- Dia 1 -->
                <div style="background: rgba(45, 212, 191, 0.1); padding: 16px; border-radius: 16px; margin-bottom: 12px; border-left: 4px solid #2DD4BF;">
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                        <span style="font-size: 24px;">🧠</span>
                        <div>
                            <h4 style="margin: 0; color: #2DD4BF;">DIA 1: Reprogramação Mental</h4>
                        </div>
                    </div>
                    <ul style="margin: 0; padding-left: 24px; color: #94A3B8; font-size: 13px;">
                        <li>Identificação dos gatilhos pessoais</li>
                        <li>Exercício de visualização do futuro</li>
                        <li>Técnica de ancoragem positiva</li>
                    </ul>
                </div>

                <!-- Dia 2 -->
                <div style="background: rgba(139, 92, 246, 0.1); padding: 16px; border-radius: 16px; margin-bottom: 12px; border-left: 4px solid #8B5CF6;">
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                        <span style="font-size: 24px;">💪</span>
                        <div>
                            <h4 style="margin: 0; color: #8B5CF6;">DIA 2: Quebra de Gatilhos</h4>
                        </div>
                    </div>
                    <ul style="margin: 0; padding-left: 24px; color: #94A3B8; font-size: 13px;">
                        <li>Dessensibilização de situações</li>
                        <li>Criação de novos hábitos</li>
                        <li>Técnicas de substituição</li>
                    </ul>
                </div>

                <!-- Dia 3 -->
                <div style="background: rgba(34, 197, 94, 0.1); padding: 16px; border-radius: 16px; border-left: 4px solid #22C55E;">
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
                        <span style="font-size: 24px;">🏆</span>
                        <div>
                            <h4 style="margin: 0; color: #22C55E;">DIA 3: Liberdade Total</h4>
                        </div>
                    </div>
                    <ul style="margin: 0; padding-left: 24px; color: #94A3B8; font-size: 13px;">
                        <li>Consolidação da nova identidade</li>
                        <li>Plano de prevenção de recaídas</li>
                        <li>Celebração e próximos passos</li>
                    </ul>
                </div>
            </div>

            <button onclick="showPremiumOffer()" style="width: 100%; padding: 16px; background: linear-gradient(135deg, #F59E0B, #D97706); color: white; border: none; border-radius: 14px; font-weight: 700; font-size: 16px; cursor: pointer;">
                🎁 Começar Agora - 3 Dias Grátis
            </button>
            <p style="text-align: center; font-size: 11px; color: #64748B; margin-top: 12px;">Acesso imediato após ativação</p>
        </div>
    `;
    document.body.appendChild(modal);
}

// ==================== MÉTODOS INFALÍVEIS ====================

const METHODS_DATA = {
    1: {
        title: 'Técnica do Copo d\'Água',
        emoji: '💧',
        description: 'Quando sentir vontade de fumar, beba um copo grande de água gelada lentamente. A água ativa o sistema parassimpático e reduz a ansiedade em 30 segundos.',
        steps: [
            'Pegue um copo grande (300ml) de água gelada',
            'Beba lentamente, em pequenos goles',
            'Concentre-se na sensação da água descendo',
            'Respire fundo 3 vezes após terminar'
        ],
        tip: 'A nicotina desidrata o corpo. Beber água ajuda a eliminá-la mais rápido!'
    },
    2: {
        title: 'Respiração 4-7-8 Turbo',
        emoji: '🌬️',
        description: 'Técnica usada por Navy SEALs para controlar o estresse. Acalma o sistema nervoso em menos de 1 minuto.',
        steps: [
            'Inspire pelo nariz contando até 4',
            'Segure a respiração contando até 7',
            'Expire pela boca contando até 8',
            'Repita 4 vezes'
        ],
        tip: 'Faça isso sempre que sentir a vontade chegar. Funciona em 90% dos casos!'
    }
};

function showMethodDetail(methodId) {
    const method = METHODS_DATA[methodId];
    if (!method) return;

    const existingModal = document.getElementById('methodModal');
    if (existingModal) existingModal.remove();

    const modal = document.createElement('div');
    modal.id = 'methodModal';
    modal.className = 'modal active';
    modal.innerHTML = `
        <div class="modal-content" style="max-width: 420px;">
            <button class="modal-close" onclick="closeModals()"><span class="material-icons">close</span></button>
            
            <div style="text-align: center; margin-bottom: 24px;">
                <span style="font-size: 56px;">${method.emoji}</span>
                <h2 style="margin: 12px 0 8px 0;">Método #${methodId}</h2>
                <h3 style="color: var(--primary); margin: 0;">${method.title}</h3>
            </div>

            <p style="color: #64748B; font-size: 14px; line-height: 1.6; margin-bottom: 20px;">${method.description}</p>

            <div style="background: #F8FAFC; padding: 20px; border-radius: 16px; margin-bottom: 20px;">
                <h4 style="margin: 0 0 12px 0; display: flex; align-items: center; gap: 8px;">
                    <span class="material-icons" style="color: var(--primary);">checklist</span>
                    Passo a Passo
                </h4>
                <ol style="margin: 0; padding-left: 20px; color: #475569; font-size: 14px; line-height: 1.8;">
                    ${method.steps.map(step => `<li>${step}</li>`).join('')}
                </ol>
            </div>

            <div style="background: #FEF3C7; padding: 16px; border-radius: 12px; display: flex; align-items: start; gap: 12px;">
                <span class="material-icons" style="color: #F59E0B;">lightbulb</span>
                <div>
                    <strong style="color: #92400E;">Dica Pro:</strong>
                    <p style="margin: 4px 0 0 0; font-size: 13px; color: #92400E;">${method.tip}</p>
                </div>
            </div>

            <button onclick="closeModals()" style="width: 100%; margin-top: 20px; padding: 14px; background: var(--gradient-primary); color: white; border: none; border-radius: 14px; font-weight: 600; cursor: pointer;">
                Entendi! Vou Praticar
            </button>
        </div>
    `;
    document.body.appendChild(modal);
}

// Breathing Logic
let breathState = 0;
function startBreathingExercise() {
    const btn = document.getElementById('startBtn');
    btn.style.display = 'none';
    runBreathCycle();
}
function runBreathCycle() {
    const circle = document.getElementById('breathingCircle');
    const text = document.getElementById('breathInstruction');

    text.textContent = 'Inspire...';
    circle.style.transform = 'scale(1.3)';
    setTimeout(() => {
        text.textContent = 'Segure...';
        setTimeout(() => {
            text.textContent = 'Expire...';
            circle.style.transform = 'scale(1)';
            setTimeout(runBreathCycle, 4000);
        }, 2000);
    }, 4000);
}
function resetBreathing() {
    document.getElementById('startBtn').style.display = 'block';
    document.getElementById('breathingCircle').style.transform = 'scale(1)';
}


// ==================== MUSIC PLAYER ====================
let isPlaying = false;
function toggleMusic() {
    const audio = document.getElementById('relaxAudio');
    const icon = document.getElementById('musicIcon');
    const status = document.getElementById('musicStatus');
    const card = document.getElementById('musicCard');

    if (isPlaying) {
        audio.pause();
        icon.textContent = 'play_circle';
        status.textContent = 'Chuva e Natureza';
        status.style.color = '#64748B';
        card.style.border = 'none';
        card.style.background = 'var(--surface)';
    } else {
        audio.play().catch(e => console.log('Autoplay prevent:', e));
        icon.textContent = 'pause_circle';
        status.textContent = 'Tocando agora...';
        status.style.color = 'var(--primary)';
        card.style.border = '1px solid var(--primary)';
        card.style.background = 'rgba(45, 212, 191, 0.05)';
    }
    isPlaying = !isPlaying;
}

// ==================== NOTIFICATION SYSTEM ====================

let swRegistration = null;

// Inicializar sistema de notificações
async function initNotifications() {
    // Verificar suporte
    if (!('Notification' in window)) {
        console.log('Notificações não suportadas neste navegador');
        return false;
    }

    // Verificar se já tem permissão
    if (Notification.permission === 'granted') {
        console.log('Permissão de notificação já concedida');
        scheduleAllDailyNotifications();
        return true;
    }

    // Se ainda não pediu, pedir após um tempo
    if (Notification.permission !== 'denied') {
        // Mostrar prompt customizado após 30 segundos de uso
        setTimeout(() => {
            showNotificationPermissionModal();
        }, 30000);
    }

    return false;
}

// Modal customizado para pedir permissão
function showNotificationPermissionModal() {
    // Não mostrar se já tem permissão
    if (Notification.permission === 'granted') return;

    // Criar modal
    const modal = document.createElement('div');
    modal.id = 'notificationModal';
    modal.className = 'modal active';
    modal.innerHTML = `
        <div class="modal-content" style="max-width: 380px; text-align: center;">
            <span class="material-icons" style="font-size: 64px; color: var(--primary); margin-bottom: 16px;">notifications_active</span>
            <h2 style="margin-bottom: 12px;">Ative as Notificações</h2>
            <p style="color: #64748B; margin-bottom: 24px; font-size: 14px;">
                Receba lembretes motivacionais, dicas de saúde e alertas de progresso para te ajudar a não desistir.
            </p>
            
            <div style="background: #F0FDF4; padding: 16px; border-radius: 12px; margin-bottom: 24px; text-align: left;">
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                    <span class="material-icons" style="color: var(--success); font-size: 18px;">check_circle</span>
                    <span style="font-size: 13px;">Lembretes matinais de motivação</span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                    <span class="material-icons" style="color: var(--success); font-size: 18px;">check_circle</span>
                    <span style="font-size: 13px;">Alertas de marcos alcançados</span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="material-icons" style="color: var(--success); font-size: 18px;">check_circle</span>
                    <span style="font-size: 13px;">Ajuda imediata em momentos de crise</span>
                </div>
            </div>

            <button onclick="requestNotificationPermission()" 
                style="width: 100%; padding: 16px; background: var(--gradient-primary); color: white; border: none; border-radius: 14px; font-weight: 600; font-size: 16px; cursor: pointer;">
                Ativar Notificações
            </button>
            <button onclick="dismissNotificationModal()" 
                style="width: 100%; padding: 12px; background: none; border: none; color: #94A3B8; font-size: 14px; margin-top: 12px; cursor: pointer;">
                Agora não
            </button>
        </div>
    `;
    document.body.appendChild(modal);
}

// Pedir permissão real do navegador
async function requestNotificationPermission() {
    try {
        const permission = await Notification.requestPermission();
        dismissNotificationModal();

        if (permission === 'granted') {
            console.log('Permissão concedida!');
            // Mostrar notificação de boas-vindas
            showInstantNotification('🎉 Notificações ativadas!', 'Você receberá lembretes para te ajudar na jornada.');
            // Agendar notificações diárias
            scheduleAllDailyNotifications();
            // Salvar preferência
            localStorage.setItem('livre_notifications', 'enabled');
        } else {
            console.log('Permissão negada');
        }
    } catch (error) {
        console.error('Erro ao pedir permissão:', error);
    }
}

// Fechar modal de permissão
function dismissNotificationModal() {
    const modal = document.getElementById('notificationModal');
    if (modal) modal.remove();
}

// Mostrar notificação instantânea
function showInstantNotification(title, body) {
    if (Notification.permission !== 'granted') return;

    if (swRegistration) {
        swRegistration.active.postMessage({
            type: 'SHOW_NOTIFICATION_NOW',
            title: title,
            body: body
        });
    } else {
        // Fallback para API direta
        new Notification(title, {
            body: body,
            icon: './icon.png'
        });
    }
}

// Agendar notificação para depois
function scheduleNotification(delayMs, timeOfDay) {
    if (Notification.permission !== 'granted') return;

    if (swRegistration && swRegistration.active) {
        swRegistration.active.postMessage({
            type: 'SCHEDULE_NOTIFICATION',
            delay: delayMs,
            timeOfDay: timeOfDay
        });
    }
}

// Agendar todas as notificações do dia
function scheduleAllDailyNotifications() {
    if (Notification.permission !== 'granted') return;

    const now = new Date();
    const currentHour = now.getHours();

    // Horários das notificações (8h, 12h, 18h, 21h)
    const schedules = [
        { hour: 8, timeOfDay: 'morning' },
        { hour: 12, timeOfDay: 'afternoon' },
        { hour: 18, timeOfDay: 'evening' },
        { hour: 21, timeOfDay: 'evening' }
    ];

    schedules.forEach(schedule => {
        // Só agendar se o horário ainda não passou
        if (schedule.hour > currentHour) {
            const targetTime = new Date();
            targetTime.setHours(schedule.hour, 0, 0, 0);
            const delay = targetTime.getTime() - now.getTime();

            console.log(`Agendando notificação para ${schedule.hour}h (em ${Math.round(delay / 60000)} min)`);
            scheduleNotification(delay, schedule.timeOfDay);
        }
    });
}

// Notificação de crise (botão de emergência)
function sendCrisisNotification() {
    showInstantNotification(
        '🚨 Momento de crise detectado',
        'Respire fundo. A vontade vai passar em 5 minutos. Você é mais forte!'
    );
}

// ==================== PROMO CARDS ====================

let deferredInstallPrompt = null;

// Capturar evento de instalação PWA
window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferredInstallPrompt = e;
    // Mostrar card de instalação
    const installCard = document.getElementById('installAppCard');
    if (installCard) {
        installCard.style.display = 'block';
    }
    console.log('PWA pode ser instalado');
});

// Função para abrir prompt de instalação
function promptInstallApp() {
    if (deferredInstallPrompt) {
        deferredInstallPrompt.prompt();
        deferredInstallPrompt.userChoice.then((choiceResult) => {
            if (choiceResult.outcome === 'accepted') {
                console.log('Usuário instalou a PWA');
                // Esconder card após instalação
                const installCard = document.getElementById('installAppCard');
                if (installCard) {
                    installCard.style.display = 'none';
                }
            }
            deferredInstallPrompt = null;
        });
    } else {
        // Mostrar instruções manuais se não houver prompt disponível
        alert('Para instalar:\n\n📱 Android: Toque nos 3 pontos do menu e selecione "Adicionar à tela inicial"\n\n🍎 iOS: Toque no botão de compartilhar e selecione "Adicionar à Tela de Início"');
    }
}

// Atualizar estado dos cards promocionais
function updatePromoCards() {
    // Card de Instalação - esconder se já instalado
    const installCard = document.getElementById('installAppCard');
    if (installCard) {
        // Verificar se está em modo standalone (instalado)
        if (window.matchMedia('(display-mode: standalone)').matches || window.navigator.standalone) {
            installCard.style.display = 'none';
        } else if (deferredInstallPrompt) {
            installCard.style.display = 'block';
        }
    }

    // Card de Notificações - atualizar estado
    const notifCard = document.getElementById('notificationsCard');
    const notifTitle = document.getElementById('notifCardTitle');
    const notifDesc = document.getElementById('notifCardDesc');
    const notifIcon = document.getElementById('notifCardIcon');

    if (notifCard && 'Notification' in window) {
        if (Notification.permission === 'granted') {
            // Já tem permissão - mostrar como ativo
            notifCard.style.background = 'linear-gradient(135deg, #22C55E 0%, #16A34A 100%)';
            if (notifTitle) notifTitle.textContent = '✓ Notificações Ativas';
            if (notifDesc) notifDesc.textContent = 'Você receberá lembretes diários';
            if (notifIcon) notifIcon.textContent = 'check_circle';
            notifCard.onclick = null; // Desabilitar clique
            notifCard.style.cursor = 'default';
        } else if (Notification.permission === 'denied') {
            // Permissão negada
            notifCard.style.background = 'linear-gradient(135deg, #64748B 0%, #475569 100%)';
            if (notifTitle) notifTitle.textContent = 'Notificações Bloqueadas';
            if (notifDesc) notifDesc.textContent = 'Ative nas configurações do navegador';
            if (notifIcon) notifIcon.textContent = 'block';
            notifCard.onclick = () => {
                alert('As notificações foram bloqueadas.\n\nPara reativar:\n1. Clique no cadeado/ícone na barra de endereço\n2. Encontre "Notificações"\n3. Altere para "Permitir"');
            };
        }
    }
}

// ==================== INIT ====================

window.onload = async function () {
    checkFirstAccess();

    // Registrar service worker e inicializar notificações
    if ('serviceWorker' in navigator) {
        try {
            swRegistration = await navigator.serviceWorker.register('./service-worker.js');
            console.log('Service Worker registrado:', swRegistration);

            // Esperar o SW estar ativo
            if (swRegistration.active) {
                initNotifications();
            } else {
                navigator.serviceWorker.ready.then(() => {
                    initNotifications();
                });
            }
        } catch (error) {
            console.error('Erro ao registrar SW:', error);
        }
    }

    // Atualizar cards promocionais após carregar
    setTimeout(updatePromoCards, 1000);
};
