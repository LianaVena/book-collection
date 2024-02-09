package vena.bookcollection;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import vena.bookcollection.book.Book;
import vena.bookcollection.book.BookRepository;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@SpringBootApplication
public class BookCollectionApplication {

  private final Logger logger = Logger.getLogger(BookCollectionApplication.class.getName());

  private final BookRepository bookRepository;

  public BookCollectionApplication(BookRepository bookRepository) {
    this.bookRepository = bookRepository;
  }

  @EventListener(ApplicationReadyEvent.class)
  public void runAfterStartup() {
    List<Book> allBooks = bookRepository.findAll();
    logger.log(Level.INFO, "!!!!!!!!!!! Number of Books {0}", allBooks.size());
    bookRepository.save(new Book(123, "book 1"));
    allBooks = bookRepository.findAll();
    logger.log(Level.INFO, "!!!!!!!!!!! Number of Books {0}", allBooks.size());
  }

  public static void main(String[] args) {
    SpringApplication.run(BookCollectionApplication.class, args);
  }

}
