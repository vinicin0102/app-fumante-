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
    document.getElementById('progressBar').style.width = `${(step / 3) * 100}%`;
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
        document.getElementById('priceDisplay').textContent = `R$ ${parseFloat(value).toFixed(2).replace('.', ',')}`;
    }

    // Atualizar estimativa mensal se os elementos existirem
    if (document.getElementById('monthlySpendDisplay')) {
        const monthly = (state.cigsPerDay / 20) * state.packPrice * 30;
        document.getElementById('monthlySpendDisplay').textContent = `R$ ${monthly.toFixed(2).replace('.', ',')}`;
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
function closeModals() {
    document.querySelectorAll('.modal').forEach(m => m.classList.remove('active'));
    resetBreathing();
}

function showBreathingExercise() {
    closeModals();
    setTimeout(() => document.getElementById('breathingModal').classList.add('active'), 100);
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

window.onload = checkFirstAccess;
