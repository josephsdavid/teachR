library(stringr)
library(text2vec)
library(LDAvis)
data("movie_review")
str(movie_review)
# select 1000 rows for faster running times

# cross validation

# overfitting

# train test split
movie_review_train <- movie_review[1:700, ]
movie_review_test <- movie_review[701:1000, ]


prep_fun <- function(x) {
  x %>% 
    # make text lower case
    str_to_lower %>% 
    # remove non-alphanumeric symbols
    str_replace_all("[^[:alpha:]]", " ") %>% 
    # collapse multiple spaces
    str_replace_all("\\s+", " ")
}
str(movie_review_train)
movie_review_train$review <- prep_fun(movie_review_train$review)
str(movie_review_train)

# 'data.frame':	700 obs. of  3 variables:
#  $ id       : chr  "5814_8" "2381_9" "7759_3" "3630_4" ...
#  $ sentiment: int  1 1 0 0 1 1 0 0 0 1 ...
#  $ review   : chr  "with all this stuff going down at the moment with mj i ve started listening to his music watching the odd docum"| __truncated__ " the classic war of the worlds by timothy hines is a very entertaining film that obviously goes to great effort"| __truncated__ "the film starts with a manager nicholas bell giving welcome investors robert carradine to primal park a secret "| __truncated__ "it must be assumed that those who praised this film the greatest filmed opera ever didn t i read somewhere eith"| __truncated__ ...
# NULL

# make the dataset in the right format
it <- itoken(movie_review_train$review, progressbar = TRUE)
v <- create_vocabulary(it) %>% 
  prune_vocabulary(doc_proportion_max = 0.1, term_count_min = 5)
vectorizer <- vocab_vectorizer(v)
dtm <- create_dtm(it, vectorizer)



tokens <- movie_review$review[1:4000] %>% 
  tolower %>% 
  word_tokenizer
it <- itoken(tokens, ids = movie_review$id[1:4000], progressbar = FALSE)
v <- create_vocabulary(it) %>% 
  prune_vocabulary(term_count_min = 10, doc_proportion_max = 0.2)
vectorizer <- vocab_vectorizer(v)
dtm <- create_dtm(it, vectorizer, type = "dgTMatrix")


#

lda_model <- LDA$new(n_topics = 10, doc_topic_prior = 0.1, topic_word_prior = 0.01)
doc_topic_distr <- lda_model$fit_transform(x = dtm, n_iter = 1000, 
                          convergence_tol = 0.001, n_check_convergence = 25, 
                          progressbar = TRUE)

lda_model$get_top_words(n = 10, topic_number = 1:10, lambda = .4)
new_dtm  <-  itoken(movie_review$review[4001:5000], tolower, word_tokenizer, ids = movie_review$id[4001:5000]) %>% 
  create_dtm(vectorizer, type = "dgTMatrix")
new_doc_topic_distr  <-  lda_model$transform(new_dtm)

options(browser = "firefox")
lda_model$plot()
