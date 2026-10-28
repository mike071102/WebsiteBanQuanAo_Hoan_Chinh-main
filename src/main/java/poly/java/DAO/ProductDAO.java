package poly.java.DAO;

import poly.java.Entity.Product;

import java.math.BigDecimal;
import java.util.List;

public interface ProductDAO {
    Product create(Product entity);
    Product update(Product entity);
    void delete(Integer id);
    Product findById(Integer id);
    List<Product> findAll();
    List<Product> findByCategoryId(Integer categoryId);
    List<Product> findActiveProducts();
    void updateViewCount(Integer productId);

    List<Product> searchProducts(String keyword, Integer categoryId, Boolean status, int page, int pageSize);
    long countSearchProducts(String keyword, Integer categoryId, Boolean status);

    List<Product> searchActiveProducts(String keyword, Integer categoryId,
                                       BigDecimal minPrice, BigDecimal maxPrice, String sort);
}