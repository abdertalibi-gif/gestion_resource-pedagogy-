// ============================================================
// FILE UPLOAD UTILITIES
// ============================================================

document.addEventListener('DOMContentLoaded', function() {
    const dropZone = document.getElementById('dropZone');
    const fileInput = document.getElementById('fichier');
    const form = document.getElementById('uploadForm');

    if (!dropZone || !fileInput) return;

    // Drag & Drop
    ['dragenter', 'dragover'].forEach(function(eventName) {
        dropZone.addEventListener(eventName, function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropZone.classList.add('dragover');
        });
    });

    ['dragleave', 'drop'].forEach(function(eventName) {
        dropZone.addEventListener(eventName, function(e) {
            e.preventDefault();
            e.stopPropagation();
            dropZone.classList.remove('dragover');
        });
    });

    dropZone.addEventListener('drop', function(e) {
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            fileInput.files = files;
            updateFileNameFromInput(fileInput);
        }
    });

    // Validation du formulaire
    if (form) {
        form.addEventListener('submit', function(e) {
            if (fileInput.files.length === 0) {
                e.preventDefault();
                showUploadError('Veuillez sélectionner un fichier');
                return;
            }

            const file = fileInput.files[0];
            const maxSize = 50 * 1024 * 1024; // 50 Mo

            if (file.size > maxSize) {
                e.preventDefault();
                showUploadError('Le fichier est trop volumineux (max 50 Mo)');
                return;
            }

            // Indicateur de chargement
            const btn = document.getElementById('submitBtn');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Envoi en cours...';
            }
        });
    }
});

function updateFileName(input) {
    updateFileNameFromInput(input);
}

function updateFileNameFromInput(input) {
    const label = document.getElementById('fileLabel');
    if (label && input.files.length > 0) {
        const file = input.files[0];
        const size = formatFileSize(file.size);
        label.innerHTML = '<strong>' + file.name + '</strong> (' + size + ')';
        label.style.color = '#10b981';
    }
}

function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' o';
    if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' Ko';
    return (bytes / 1048576).toFixed(1) + ' Mo';
}

function showUploadError(message) {
    const zone = document.getElementById('dropZone');
    // Retirer l'ancienne erreur si elle existe
    const oldError = zone.querySelector('.upload-error');
    if (oldError) oldError.remove();

    const errorDiv = document.createElement('div');
    errorDiv.className = 'upload-error';
    errorDiv.style.cssText = 'color: #ef4444; font-size: 13px; margin-top: 8px; font-weight: 600;';
    errorDiv.textContent = message;
    zone.appendChild(errorDiv);

    setTimeout(function() { errorDiv.remove(); }, 4000);
}