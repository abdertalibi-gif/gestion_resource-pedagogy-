// ============================================================
// MAIN UTILITIES
// ============================================================

// Sidebar toggle (mobile)
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    if (sidebar) {
        sidebar.classList.toggle('open');
    }
}

// Fermer sidebar au clic en dehors (mobile)
document.addEventListener('click', function(e) {
    const sidebar = document.getElementById('sidebar');
    const hamburger = document.querySelector('.hamburger');
    if (sidebar && sidebar.classList.contains('open')) {
        if (!sidebar.contains(e.target) && !hamburger.contains(e.target)) {
            sidebar.classList.remove('open');
        }
    }
});

// Notification dropdown toggle
function toggleNotif() {
    const menu = document.getElementById('notifMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

// Fermer notification dropdown au clic en dehors
document.addEventListener('click', function(e) {
    const dropdown = document.getElementById('notifDropdown');
    const menu = document.getElementById('notifMenu');
    if (dropdown && menu && menu.classList.contains('show')) {
        if (!dropdown.contains(e.target)) {
            menu.classList.remove('show');
        }
    }
});

// Auto-hide des alertes apres 5 secondes
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function() { alert.remove(); }, 300);
        }, 5000);
    });
});

// Confirmation avant suppression (fallback si onclick inline absent)
document.addEventListener('click', function(e) {
    if (e.target.closest('.btn-delete')) {
        const link = e.target.closest('.btn-delete');
        if (!link.dataset.confirmed) {
            e.preventDefault();
            if (confirm('Êtes-vous sûr de vouloir supprimer ?')) {
                link.dataset.confirmed = 'true';
                link.click();
            }
        }
    }
});

// Smooth scroll pour les liens d'ancrage
document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
    anchor.addEventListener('click', function(e) {
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            e.preventDefault();
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});