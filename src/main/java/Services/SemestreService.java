package Services;

import java.util.List;

import dao.DAOFactory;
import dao.SemestreDAO;
import models.Semestre;

public class SemestreService {

    private final SemestreDAO semestreDAO;

    public SemestreService() {
        this.semestreDAO = DAOFactory.getSemestreDAO();
    }

    private static final String[] SEMESTRES_STANDARD = {"S1", "S2", "S3", "S4", "S5", "S6"};
    private static final String[] SEMESTRES_DESC = {
        "Premier semestre", "Deuxième semestre", "Troisième semestre",
        "Quatrième semestre", "Cinquième semestre", "Sixième semestre"
    };

    public void ensureSemestresStandard() {
        for (int i = 0; i < SEMESTRES_STANDARD.length; i++) {
            if (semestreDAO.findByNom(SEMESTRES_STANDARD[i]) == null) {
                Semestre s = new Semestre();
                s.setNomSemestre(SEMESTRES_STANDARD[i]);
                s.setDescription(SEMESTRES_DESC[i]);
                semestreDAO.insert(s);
            }
        }
    }

    public List<Semestre> findAll() {
        ensureSemestresStandard();
        return semestreDAO.findAll();
    }

    public Semestre findById(int id) { return semestreDAO.findById(id); }

    public boolean create(Semestre s) { return semestreDAO.insert(s) > 0; }
    public boolean update(Semestre s) { return semestreDAO.update(s); }
    public boolean delete(int id) { return semestreDAO.delete(id); }
    public int count() { return semestreDAO.count(); }
}