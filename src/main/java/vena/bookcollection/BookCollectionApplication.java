package vena.bookcollection;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import vena.bookcollection.book.BookRepository;

import java.io.IOException;
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
    try {
      // fetching the target website
      Document doc = Jsoup
          .connect("https://www.goodreads.com/search?q=9780241454695")
          .userAgent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36")
          .header("Accept-Language", "*")
          .get();
      Elements elements = doc.getElementsByClass("Text Text__title1");
      logger.log(Level.INFO, elements.text());
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
//    List<Book> allBooks = bookRepository.findAll();
//    logger.log(Level.INFO, "!!!!!!!!!!! Number of Books {0}", allBooks.size());
//    bookRepository.save(new Book(123, "book 1"));
//    allBooks = bookRepository.findAll();
//    logger.log(Level.INFO, "!!!!!!!!!!! Number of Books {0}", allBooks.size());
  }

  public static void main(String[] args) {
    SpringApplication.run(BookCollectionApplication.class, args);
  }

}
