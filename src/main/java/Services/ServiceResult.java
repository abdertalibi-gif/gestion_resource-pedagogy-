package Services;

import java.util.ArrayList;
import java.util.List;

/**
 * Resultat d'une operation de service.
 * Contient soit un succes avec donnees, soit une liste d'erreurs.
 */
public class ServiceResult<T> {

    private boolean success;
    private T data;
    private List<String> errors;
    private String message;

    private ServiceResult(boolean success, T data, List<String> errors, String message) {
        this.success = success;
        this.data = data;
        this.errors = errors;
        this.message = message;
    }

    public static <T> ServiceResult<T> success(T data, String message) {
        return new ServiceResult<>(true, data, null, message);
    }

    public static <T> ServiceResult<T> failure(String error) {
        List<String> errors = new ArrayList<>();
        errors.add(error);
        return new ServiceResult<>(false, null, errors, null);
    }

    public static <T> ServiceResult<T> failure(List<String> errors) {
        return new ServiceResult<>(false, null, errors, null);
    }

    public boolean isSuccess() { return success; }
    public T getData() { return data; }
    public List<String> getErrors() { return errors; }
    public String getMessage() { return message; }
}