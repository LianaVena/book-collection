package vena.bookcollection.book;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@RestController
public class BookController {

  private static final String AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36";
  private static final List<String> HEADER = Arrays.asList("Accept-Language", "*");

  private final Logger logger = Logger.getLogger(BookController.class.getName());

  @GetMapping("/title/{isbn}")
  public ResponseEntity<String> getTitle(@PathVariable String isbn) {
    try {
      Document doc = Jsoup
          .connect("https://www.goodreads.com/search?q=" + isbn)
          .userAgent(AGENT)
          .header(HEADER.get(0), HEADER.get(1))
          .get();
      Elements title = doc.getElementsByClass("Text Text__title1");
      String result = title.text();
      if (title.isEmpty()) {
        logger.log(Level.INFO, result);
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
      }
      return ResponseEntity.ok(result);
    } catch (IOException e) {
      return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }
  }
}
