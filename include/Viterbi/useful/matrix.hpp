/**
 * @brief C++14 matrix implementation
 * */

#ifndef USEFULL_MATRIX_HPP
#define USEFULL_MATRIX_HPP

#include <memory>  // shared_ptr

namespace useful {
namespace matrix {

template <typename T>
class Matrix {
 public:
  /* Constructors */
  Matrix<T>() = default;

  Matrix<T>(Matrix<T> const& other) = default;
  Matrix<T>& operator=(Matrix<T> const& other) = default;

  Matrix<T>(Matrix<T>&& other) = default;
  Matrix<T>& operator=(Matrix<T>&& other) = default;

  ~Matrix<T>() = default;

  /* Operators */

  /**
   * Get number of column.
   * */
  size_t nb_col() const;

  /**
   * Get number of rows.
   * */
  size_t nb_row() const;

  /**
   * Get a copy of an element of the matrix.
   * */
  T at(size_t i, size_t j) const;

  /**
   * Set an element of the matrix.
   * @note Store a copy.
   * */
  void set(const T& val, size_t i, size_t j);

  /**
   * Resize the matrix
   * @note If the new size is smaller, elements are discards.
   * */
  void resize(size_t i, size_t j);

 protected:
  size_t nbRow;                                           // Number of row
  size_t nbCol;                                           // Number of column
  std::vector<std::shared_ptr<std::vector<T>>> data;  // Storage

 private:
};

// #define MTXTMP template <typename T, unsigned int rows, unsigned int cols>

// /* Matrix class template */
// MTXTMP class matrix {
//  public:
//   matrix();
//   matrix(std::initializer_list<std::initializer_list<T> > list);

//   std::array<T, cols> getrow(unsigned int row) const;
//   std::array<T, rows> getcol(unsigned int col) const;
//   T getval(unsigned int row, unsigned int col) const;
//   void setval(unsigned int row, unsigned int col, const T val);
//   matrix<T, cols, rows> transpose() const;
//   matrix<T, rows, cols> operator+() const;
//   matrix<T, rows, cols> operator+(const matrix<T, rows, cols>& operand)
//   const; matrix<T, rows, cols>& operator+=(const matrix<T, rows, cols>&
//   operand); matrix<T, rows, cols> operator-() const; matrix<T, rows, cols>
//   operator-(const matrix<T, rows, cols>& operand) const; matrix<T, rows,
//   cols>& operator-=(const matrix<T, rows, cols>& operand); matrix<T, rows,
//   cols> operator*(const T operand) const; matrix<T, rows, cols>&
//   operator*=(const T operand); template <unsigned int opcols> matrix<T, rows,
//   opcols> operator*(
//       const matrix<T, cols, opcols>& operand) const;
//   T determinant() const;
//   matrix<T, rows, cols> invert() const;
//   template <typename T_, unsigned int rows_, unsigned int cols_>
//   bool operator==(const matrix<T_, rows_, cols_>& operand) const;
//   template <typename T_, unsigned int rows_, unsigned int cols_>
//   bool operator!=(const matrix<T_, rows_, cols_>& operand) const;
//   bool is_upper_triangular() const;
//   bool is_lower_triangular() const;
//   bool is_triangular() const;
//   bool is_diagonal() const;

//  private:
//   std::array<std::array<T, cols>, rows> myVal;
//   template <typename T_, unsigned int rows_, unsigned int cols_>
//   struct calc_det {
//     T_ operator()(const matrix<T_, rows_, cols_>&) const;
//   };
//   template <typename T_>
//   struct calc_det<T_, 1, 1> {
//     T_ operator()(const matrix<T_, 1, 1>&) const;
//   };
//   template <typename T_>
//   struct calc_det<T_, 2, 2> {
//     T_ operator()(const matrix<T_, 2, 2>&) const;
//   };
//   template <typename T_, unsigned int size>
//   struct calc_det<T_, size, size> {
//     T_ operator()(const matrix<T_, size, size>&) const;
//   };
//   template <typename T_, unsigned int rows_, unsigned int cols_>
//   struct calc_inv {
//     const matrix<T_, rows_, cols_> operator()(
//         const matrix<T_, rows_, cols_>&) const;
//   };
//   template <typename T_>
//   struct calc_inv<T_, 1, 1> {
//     const matrix<T_, 1, 1> operator()(const matrix<T_, 1, 1>&) const;
//   };
//   template <typename T_>
//   struct calc_inv<T_, 2, 2> {
//     const matrix<T_, 2, 2> operator()(const matrix<T_, 2, 2>&) const;
//   };
//   template <typename T_, unsigned int size>
//   struct calc_inv<T_, size, size> {
//     const matrix<T_, size, size> operator()(
//         const matrix<T_, size, size>&) const;
//   };
//   template <typename T_, unsigned int rows_, unsigned int cols_>
//   struct calc_uptriag {
//     bool operator()(const matrix<T_, rows_, cols_>&) const;
//   };
//   template <typename T_, unsigned int size>
//   struct calc_uptriag<T_, size, size> {
//     bool operator()(const matrix<T_, size, size>&) const;
//   };
//   template <typename T_, unsigned int rows_, unsigned int cols_>
//   struct calc_lwtriag {
//     bool operator()(const matrix<T_, rows_, cols_>&) const;
//   };
//   template <typename T_, unsigned int size>
//   struct calc_lwtriag<T_, size, size> {
//     bool operator()(const matrix<T_, size, size>&) const;
//   };
// };

}  // namespace matrix
}  // namespace useful

// include template implementation
#include "useful/matrix.tpp"

#endif /* End USEFULL_MATRIX_HPP */