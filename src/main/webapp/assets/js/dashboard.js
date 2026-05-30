// ============================================================
// DASHBOARD UTILITIES
// ============================================================

document.addEventListener('DOMContentLoaded', function() {

    // Animation des compteurs (effet de comptage)
    const counters = document.querySelectorAll('.stat-card-number');
    counters.forEach(function(counter) {
        const target = parseInt(counter.textContent);
        if (isNaN(target) || target === 0) return;

        let current = 0;
        const increment = Math.max(1, Math.ceil(target / 40));
        const duration = 800;
        const stepTime = duration / (target / increment);

        counter.textContent = '0';

        const timer = setInterval(function() {
            current += increment;
            if (current >= target) {
                counter.textContent = target;
                clearInterval(timer);
            } else {
                counter.textContent = current;
            }
        }, stepTime);
    });

    // Activer le lien de navigation courant selon l'URL
    highlightCurrentNav();
});

function highlightCurrentNav() {
    const path = window.location.pathname;
    const links = document.querySelectorAll('.nav-link');
    links.forEach(function(link) {
        link.classList.remove('active');
        const href = link.getAttribute('href');
        if (href && path.endsWith(href)) {
            link.classList.add('active');
        }
    });
}