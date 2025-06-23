// Vue.js Application
const app = new Vue({
    el: '#app',
    data: {
        isActive: false,
        currentView: 'selection', // selection, creation, spawn
        characters: [],
        selectedCharacter: null,
        newCharacter: {
            firstName: '',
            lastName: '',
            backstory: '',
            lifestyle: null,
            appearance: {}
        },
        spawnLocations: [],
        lifestyles: [
            { id: 'highlife', name: 'High Life', icon: 'fas fa-crown' },
            { id: 'suburban', name: 'Suburban', icon: 'fas fa-home' },
            { id: 'criminal', name: 'Criminal', icon: 'fas fa-skull' },
            { id: 'business', name: 'Business', icon: 'fas fa-briefcase' }
        ],
        audioController: null,
        particleSystem: null
    },
    computed: {
        canGoBack() {
            return this.currentView !== 'selection';
        },
        canGoForward() {
            return (this.currentView === 'selection' && this.selectedCharacter) ||
                   (this.currentView === 'creation' && this.isCharacterValid()) ||
                   this.currentView === 'spawn';
        },
        showDelete() {
            return this.currentView === 'selection' && this.selectedCharacter;
        }
    },
    methods: {
        // Navigation
        previousStep() {
            switch(this.currentView) {
                case 'spawn':
                    this.currentView = this.selectedCharacter ? 'selection' : 'creation';
                    break;
                case 'creation':
                    this.currentView = 'selection';
                    break;
            }
            this.playTransitionSound('back');
        },
        
        nextStep() {
            switch(this.currentView) {
                case 'selection':
                    if (this.selectedCharacter) {
                        this.currentView = 'spawn';
                    }
                    break;
                case 'creation':
                    if (this.isCharacterValid()) {
                        this.createCharacter();
                    }
                    break;
                case 'spawn':
                    this.spawnCharacter();
                    break;
            }
            this.playTransitionSound('next');
        },
        
        // Character Selection
        selectCharacter(char) {
            this.selectedCharacter = char;
            this.playSelectSound();
            this.triggerHologramEffect();
            $.post('https://r1mus_registro/previewCharacter', JSON.stringify({
                charid: char.id
            }));
        },
        
        previewCharacter(char) {
            this.playHoverSound();
            $.post('https://r1mus_registro/hoverCharacter', JSON.stringify({
                charid: char.id
            }));
        },
        
        // Character Creation
        isCharacterValid() {
            return this.newCharacter.firstName &&
                   this.newCharacter.lastName &&
                   this.newCharacter.lifestyle;
        },
        
        createCharacter() {
            $.post('https://r1mus_registro/createCharacter', JSON.stringify(this.newCharacter));
            this.currentView = 'spawn';
        },
        
        selectLifestyle(lifestyle) {
            this.newCharacter.lifestyle = lifestyle;
            this.playSelectSound();
        },
        
        // Spawn System
        selectSpawn(location) {
            $.post('https://r1mus_registro/selectSpawn', JSON.stringify(location));
        },
        
        previewSpawn(location) {
            this.playHoverSound();
            $.post('https://r1mus_registro/previewSpawn', JSON.stringify(location));
        },
        
        spawnCharacter() {
            $.post('https://r1mus_registro/spawnCharacter', JSON.stringify({
                charid: this.selectedCharacter.id,
                location: this.selectedSpawnLocation
            }));
        },
        
        // Visual Effects
        triggerHologramEffect() {
            // Implement advanced hologram effect
            if (!this.particleSystem) {
                this.particleSystem = new ParticleSystem();
            }
            this.particleSystem.emit('hologram', {
                target: '.character-card.active',
                duration: 2000
            });
        },
        
        // Audio System
        initAudio() {
            this.audioController = new AudioController();
            this.audioController.preloadSounds({
                hover: 'sounds/hover.mp3',
                select: 'sounds/select.mp3',
                transition: 'sounds/transition.mp3'
            });
        },
        
        playHoverSound() {
            this.audioController.play('hover', { volume: 0.2 });
        },
        
        playSelectSound() {
            this.audioController.play('select', { volume: 0.4 });
        },
        
        playTransitionSound(type) {
            this.audioController.play('transition', {
                volume: 0.3,
                pitch: type === 'next' ? 1.1 : 0.9
            });
        },
        
        // Utility Functions
        formatNumber(num) {
            return new Intl.NumberFormat().format(num);
        },
        
        formatDate(date) {
            return new Date(date).toLocaleDateString();
        }
    },
    mounted() {
        // Initialize the interface
        this.initAudio();
        setTimeout(() => {
            this.isActive = true;
        }, 500);
        
        // Listen for NUI messages
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            switch(data.action) {
                case 'show':
                    this.characters = data.characters;
                    this.spawnLocations = data.spawnLocations;
                    this.isActive = true;
                    break;
                case 'hide':
                    this.isActive = false;
                    break;
                case 'updateCharacters':
                    this.characters = data.characters;
                    break;
            }
        });
    }
});

// Particle System Class
class ParticleSystem {
    constructor() {
        this.effects = {
            hologram: this.createHologramEffect,
            sparkle: this.createSparkleEffect
        };
    }
    
    emit(effectType, options) {
        if (this.effects[effectType]) {
            this.effects[effectType](options);
        }
    }
    
    createHologramEffect(options) {
        // Implement hologram particle effect
    }
    
    createSparkleEffect(options) {
        // Implement sparkle particle effect
    }
}

// Audio Controller Class
class AudioController {
    constructor() {
        this.sounds = {};
    }
    
    preloadSounds(soundConfig) {
        Object.entries(soundConfig).forEach(([key, path]) => {
            const audio = new Audio(path);
            audio.load();
            this.sounds[key] = audio;
        });
    }
    
    play(soundId, options = {}) {
        if (this.sounds[soundId]) {
            const sound = this.sounds[soundId].cloneNode();
            sound.volume = options.volume || 1;
            if (options.pitch) {
                sound.playbackRate = options.pitch;
            }
            sound.play();
        }
    }
}
