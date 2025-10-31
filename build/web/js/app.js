document.addEventListener('DOMContentLoaded', () => {
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  const storedTheme = localStorage.getItem('app-theme');
  let activeTheme = storedTheme || (prefersDark ? 'dark' : 'light');
  
    const updateThemeAssets = () => {
        document.querySelectorAll('[data-theme-logo]').forEach((logo) => {
            const darkSrc = logo.getAttribute('data-logo-dark');
            const lightSrc = logo.getAttribute('data-logo-light');
            const desiredSrc = activeTheme === 'dark' ? darkSrc || lightSrc : lightSrc || darkSrc;

            if (desiredSrc && logo.getAttribute('src') !== desiredSrc) {
                logo.setAttribute('src', desiredSrc);
            }
        });
    };


  const applyTheme = (theme) => {
    activeTheme = theme;
    document.body.setAttribute('data-theme', theme);
    document.documentElement.style.colorScheme = theme === 'dark' ? 'dark' : 'light';
    localStorage.setItem('app-theme', theme);
    updateThemeAssets();
  };

  applyTheme(activeTheme);

  const updateToggleButton = (button) => {
    const icon = button.querySelector('[data-theme-icon]');
    const label = button.querySelector('[data-theme-label]');
    if (icon) {
      icon.className = activeTheme === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
    }
    if (label) {
      label.textContent = activeTheme === 'dark' ? 'Modo Claro' : 'Modo Oscuro';
    }
    button.setAttribute('aria-pressed', activeTheme === 'dark' ? 'true' : 'false');
  };

  document.querySelectorAll('[data-action="toggle-theme"]').forEach((button) => {
    updateToggleButton(button);
    button.addEventListener('click', () => {
      applyTheme(activeTheme === 'dark' ? 'light' : 'dark');
      document.querySelectorAll('[data-action="toggle-theme"]').forEach(updateToggleButton);
    });
  });

  const navBar = document.querySelector('.app-navbar');
  if (navBar) {
    const toggleNavShadow = () => {
      if (window.scrollY > 12) {
        navBar.classList.add('navbar-scrolled');
      } else {
        navBar.classList.remove('navbar-scrolled');
      }
    };
    toggleNavShadow();
    window.addEventListener('scroll', toggleNavShadow);
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-visible');
        observer.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.2,
  });

  document.querySelectorAll('[data-animate]').forEach((element) => {
    observer.observe(element);
  });

  document.querySelectorAll('.app-card').forEach((card) => {
    card.addEventListener('mouseenter', () => card.classList.add('is-hovered'));
    card.addEventListener('mouseleave', () => card.classList.remove('is-hovered'));
  });

  if (window.matchMedia('(pointer: fine)').matches) {
    const tiltCards = document.querySelectorAll('.option-card, .app-card');
    const maxTilt = 10;

    const resetTilt = (card) => {
      card.style.setProperty('--tilt-x', '0deg');
      card.style.setProperty('--tilt-y', '0deg');
    };

    tiltCards.forEach((card) => {
      card.addEventListener('mousemove', (event) => {
        const rect = card.getBoundingClientRect();
        const x = event.clientX - rect.left;
        const y = event.clientY - rect.top;
        const rotateY = ((x - rect.width / 2) / (rect.width / 2)) * maxTilt;
        const rotateX = ((y - rect.height / 2) / (rect.height / 2)) * -maxTilt;
        card.style.setProperty('--tilt-x', `${rotateX.toFixed(2)}deg`);
        card.style.setProperty('--tilt-y', `${rotateY.toFixed(2)}deg`);
      });

      card.addEventListener('mouseleave', () => {
        resetTilt(card);
      });

      card.addEventListener('blur', () => resetTilt(card));
    });
  }

  if (window.bootstrap) {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach((tooltipTriggerEl) => new window.bootstrap.Tooltip(tooltipTriggerEl));
  }
  
    const togglePasswordVisibility = (toggle, input, icon) => {
        const isVisible = input.type === 'text';
        input.type = isVisible ? 'password' : 'text';
        toggle.setAttribute('aria-pressed', (!isVisible).toString());
        toggle.setAttribute('aria-label', isVisible ? 'Mostrar contraseña' : 'Ocultar contraseña');
        if (icon) {
            icon.className = isVisible ? 'bi bi-eye' : 'bi bi-eye-slash';
        }
    };

    document.querySelectorAll('[data-password-toggle]').forEach((toggle) => {
    const targetSelector = toggle.getAttribute('data-password-toggle');
            if (!targetSelector) {
            return;
    }

    const input = document.querySelector(targetSelector);
            if (!input) {
            return;
    }

    const icon = toggle.querySelector('[data-password-icon]');
        toggle.setAttribute('aria-label', 'Mostrar contraseña');
        toggle.setAttribute('aria-pressed', 'false');
        toggle.addEventListener('click', () => {
        togglePasswordVisibility(toggle, input, icon);
    });
    });
});
