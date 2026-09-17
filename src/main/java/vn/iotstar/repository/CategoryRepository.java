package vn.iotstar.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Category;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    // Search by name
    List<Category> findByCategoryNameContaining(String name);

    // Search by name with Pagination
    Page<Category> findByCategoryNameContaining(String name, Pageable pageable);

    Optional<Category> findByCategoryName(String name);
}
