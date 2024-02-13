package vena.bookcollection.book;

import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "book")
public class Book {

  @Id
  @GeneratedValue
  @Column(name = "id")
  private UUID id;

  @Column(name = "isbn", unique = true, nullable = false)
  private int isbn;

  @Column(name = "title")
  private String title;

  public Book() {
  }

  public Book(int isbn, String title) {
    this.isbn = isbn;
    this.title = title;
  }
}
