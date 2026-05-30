package Services;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import jakarta.servlet.http.HttpSession;
import models.Utilisateur;
import utils.Constants;

public class AmiService {

    private static final String SESSION_AMIS = "amisProfesseur";

    private final UtilisateurService utilisateurService = new UtilisateurService();

    @SuppressWarnings("unchecked")
    public Set<Integer> getAmiIds(HttpSession session) {
        Set<Integer> amis = (Set<Integer>) session.getAttribute(SESSION_AMIS);
        if (amis == null) {
            amis = new LinkedHashSet<>();
            session.setAttribute(SESSION_AMIS, amis);
        }
        return amis;
    }

    public void ajouter(HttpSession session, int id) {
        getAmiIds(session).add(id);
    }

    public void retirer(HttpSession session, int id) {
        getAmiIds(session).remove(id);
    }

    public List<Utilisateur> getAmis(HttpSession session) {
        Set<Integer> ids = getAmiIds(session);
        return utilisateurService.findByRole(Constants.ROLE_PROFESSEUR).stream()
                .filter(u -> ids.contains(u.getIdUtilisateur()))
                .toList();
    }

    public List<Utilisateur> getSuggestions(int currentUserId, HttpSession session) {
        Set<Integer> ids = getAmiIds(session);
        return utilisateurService.findByRole(Constants.ROLE_PROFESSEUR).stream()
                .filter(u -> u.getIdUtilisateur() != currentUserId
                        && !ids.contains(u.getIdUtilisateur()))
                .toList();
    }

    public int countAmis(HttpSession session) {
        return getAmiIds(session).size();
    }
}
