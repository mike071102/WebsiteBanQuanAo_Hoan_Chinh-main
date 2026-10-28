<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="container" style="margin-top: 30px; margin-bottom: 80px;">
    <div style="display: flex; gap: 30px;">
        <aside style="width: 250px; flex-shrink: 0;">
            <h3 class="section-title" style="font-size: 1.2rem; margin-bottom: 15px;">Danh Mục</h3>
            <ul style="list-style: none; padding: 0;">
                <li style="margin-bottom: 10px;">
                    <a href="${pageContext.request.contextPath}/products"
                       style="text-decoration: none; color: ${empty selectedCategoryId ? 'var(--accent)' : 'var(--text-primary)'}; font-weight: ${empty selectedCategoryId ? '700' : 'normal'};">
                        Tất cả sản phẩm
                    </a>
                </li>
                <c:forEach var="cat" items="${categories}">
                    <li style="margin-bottom: 10px;">
                        <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}"
                           style="text-decoration: none; color: ${selectedCategoryId == cat.id ? 'var(--accent)' : 'var(--text-primary)'}; font-weight: ${selectedCategoryId == cat.id ? '700' : 'normal'};">
                                ${cat.categoryName}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </aside>
        <main style="flex: 1;">
            <h2 class="section-title" style="margin-bottom: 20px;">
                <c:choose>
                    <c:when test="${not empty keyword}">Kết quả cho "<c:out value="${keyword}"/>"</c:when>
                    <c:otherwise>Sản Phẩm</c:otherwise>
                </c:choose>
            </h2>
            <form action="${pageContext.request.contextPath}/products" method="get" accept-charset="UTF-8"
                  style="display: flex; flex-wrap: wrap; gap: 10px; align-items: center; margin-bottom: 20px;">
                <input type="text" name="keyword" value="<c:out value='${keyword}'/>"
                       placeholder="Tìm theo tên, thương hiệu, danh mục..."
                       style="flex: 1; min-width: 220px; padding: 10px 14px; border: 1px solid #d1d5db; border-radius: 8px; color: #000; background: #fff;">

                <c:if test="${not empty selectedCategoryId}">
                    <input type="hidden" name="categoryId" value="${selectedCategoryId}">
                </c:if>

                <input type="number" name="minPrice" min="0" step="1000" value="${minPrice}" placeholder="Giá từ"
                       style="width: 120px; padding: 10px; border: 1px solid #d1d5db; border-radius: 8px; color: #000; background: #fff;">
                <input type="number" name="maxPrice" min="0" step="1000" value="${maxPrice}" placeholder="Giá đến"
                       style="width: 120px; padding: 10px; border: 1px solid #d1d5db; border-radius: 8px; color: #000; background: #fff;">

                <select name="sort" style="padding: 10px; border: 1px solid #d1d5db; border-radius: 8px; color: #000; background: #fff;">
                    <option value="" ${empty sort ? 'selected' : ''}>Mới nhất</option>
                    <option value="bestseller" ${sort == 'bestseller' ? 'selected' : ''}>Bán chạy</option>
                    <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                    <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                </select>

                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                </button>

                <c:if test="${searching or not empty sort}">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary" style="padding: 10px 14px;">Xóa lọc</a>
                </c:if>
            </form>

            <!-- Số kết quả tìm được -->
            <c:if test="${searching}">
                <p style="color: var(--text-secondary); margin-bottom: 15px;">Tìm thấy <strong>${resultCount}</strong> sản phẩm.</p>
            </c:if>
            <!-- ===== HẾT FORM TÌM KIẾM ===== -->

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="grid-products">
                        <c:forEach var="prod" items="${products}">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${prod.id}" class="product-card" style="text-decoration: none; color: inherit; display: block; cursor: pointer;">
                                <c:if test="${prod.discountPrice != null && prod.discountPrice > 0}">
                                    <span class="product-badge">SALE</span>
                                </c:if>
                                <div class="product-image-wrapper">
                                    <img src="${prod.imageUrl}" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';" alt="${prod.productName}">
                                </div>
                                <div class="product-info">
                                    <div class="product-brand">${prod.brandID.brandName}</div>
                                    <h4 class="product-name" style="margin: 0;">${prod.productName}</h4>
                                    <div class="product-price-wrapper">
                                        <c:choose>
                                            <c:when test="${prod.discountPrice != null && prod.discountPrice > 0}">
                                                <span class="product-price discounted">
                                                    <fmt:formatNumber value="${prod.discountPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                                <span class="product-old-price">
                                                    <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="product-price">
                                                    <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="text-align: center; color: var(--text-secondary); margin-top: 50px;">
                        <c:choose>
                            <c:when test="${searching}">Không tìm thấy sản phẩm phù hợp. Hãy thử từ khóa hoặc khoảng giá khác.</c:when>
                            <c:otherwise>Không tìm thấy sản phẩm nào trong danh mục này.</c:otherwise>
                        </c:choose>
                    </p>
                </c:otherwise>
            </c:choose>
        </main>

    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>