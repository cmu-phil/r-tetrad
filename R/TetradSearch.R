# Description: This file contains the TetradSearch class definition.
#
# The TetradSearch class is a reference class that provides an interface to the
# Tetrad search algorithms. It allows the user to run various algorithms and
# print the resulting graph structure.
TetradSearch <- setRefClass(
  "TetradSearch",

  fields = list(
    data = "data.frame",          # Input dataset
    sample_size = "numeric",      # Sample size
    vars = "ANY",                 # Variables for the covariance matrix
    cov = "ANY",                  # Covariance matrix
    score = "ANY",                # Score object
    test = "ANY",                 # IndependenceTest object
    knowledge = "ANY",            # Background knowledge object
    graph = "ANY"                 # Resulting graph
  ),

  methods = list(

    # Initialize the TetradSearch object
    #
    # @param data A data frame containing the dataset to be analyzed.
    # @return A TetradSearch object.
    initialize = function(data) {
      cat("Initializing TetradSearch object...\n")

      if (!is.data.frame(data)) {
        stop("Data must be a data.frame")
      }

      .self$data <- data
      .self$sample_size <- nrow(data)
      cat("Data frame dimensions:", dim(data), "\n")
      cat("Sample size set to:", .self$sample_size, "\n")

      i <- c(1, ncol(data))
      data[, i] <<- apply(data[, i], 2, as.numeric)
      .self$vars <- create_variables(data)

      .self$cov <- .jnew("edu/cmu/tetrad/data/CovarianceMatrix",
                         .self$vars,
                         .jarray(as.matrix(cov(data)), dispatch = TRUE),
                         as.integer(.self$sample_size))
      cat("Covariance matrix created.\n")

      .self$knowledge <- .jnew("edu/cmu/tetrad/data/Knowledge")
      cat("Knowledge instance created.\n")
      cat("TetradSearch object initialized successfully.\n")
    },

    # Make sure the score object is initialized
    .check_score = function() {
      if (is.null(.self$score)) {
        stop("Error: The 'score' field has not been initialized yet. Please \
                 set a score before running the algorithm.")
      }
    },

    .set_knowledge = function(search) {
      .jcall(search, "V", "setKnowledge", .jcast(.self$knowledge, "edu.cmu.tetrad.data.Knowledge"))
    },

    # Run the search algorithm, for the typical case
    .run_search = function(search) {
      .self$.set_knowledge(search)
      .self$graph <- .jcast(search$search(), "edu.cmu.tetrad.graph.Graph")
    },

    # Make sure the test object is initialized
    .check_test = function() {
      if (is.null(.self$test)) {
        stop("Error: The 'test' field has not been initialized yet. Please \
                 set a test before running the algorithm.")
      }
    },

    # Add a variable to a specific tier in the knowledge
    #
    # @param tier The tier to which the variable should be added.
    # @param var_name The name of the variable to add.
    add_to_tier = function(tier, var_name) {
      tryCatch({
        tier <- as.integer(tier)
        var_name <- as.character(var_name)
        .jcall(.self$knowledge, "V", "addToTier", tier, var_name)
        cat("Variable", var_name, "added to tier", tier, ".\n")
      }, error = function(e) {
        cat("Error adding variable to tier:", e$message, "\n")
      })
    },

    # Set the score to the SEM BIC.
    #
    # @param penalty_discount The penalty discount to use in the SemBicScore calculation.
    use_sem_bic = function(penalty_discount = 2) {
      score1 <- .jnew("edu.cmu.tetrad.search.score.SemBicScore",
                      .jcast(.self$cov, "edu.cmu.tetrad.data.ICovarianceMatrix"))
      .self$score <- .jcast(score1, "edu.cmu.tetrad.search.score.Score")
      .jcall(.self$score, "V", "setPenaltyDiscount", penalty_discount)

      cat("SemBicScore object created with penalty discount set.\n")
    },

    # Set the test to Fisher Z
    #
    # @param alpha The significance cutoff.
    use_fisher_z = function(alpha = 0.01) {
      test1 <- .jnew("edu.cmu.tetrad.search.test.IndTestFisherZ",
                     .jcast(.self$cov, "edu.cmu.tetrad.data.ICovarianceMatrix"),
                     alpha)
      .self$test <- .jcast(test1, "edu.cmu.tetrad.search.IndependenceTest")
      # .jcall(.self$test, "V", "setAlpha", alpha)

      cat("Fisher Z object created with alpha set.\n")
    },

    # Run the PC algorithm
    #
    # @return The resulting graph from the PC algorithm.
    run_pc = function() {
      cat("Running PC algorithm...\n")
      tryCatch({
        .self$.check_test()
        search <- .jnew("edu.cmu.tetrad.search.Pc",
                        .jcast(.self$test, "edu.cmu.tetrad.search.IndependenceTest"))
        .self$.run_search(search)
        cat("PC algorithm completed. Graph generated.\n")
      }, error = function(e) {
        stop("Error during PC algorithm execution:", e$message, "\n")
      })

      return(.self$graph)
    },

    # Run the FGES algorithm
    #
    # @return The resulting graph from the FGES algorithm.
    run_fges = function() {
      cat("Running FGES algorithm...\n")

      tryCatch({
        .self$.check_score()
        search <- .jnew("edu.cmu.tetrad.search.Fges", .self$score)
        .self$.run_search(search)
        cat("FGES algorithm completed. Graph generated.\n")
      }, error = function(e) {
        # Print the error message for debugging
        stop("Error during FGES algorithm execution: ", e$message, "\n")
      })

      return(.self$graph)
    },

    # Run the BOSS algorithm
    #
    # @return The resulting graph from the BOSS algorithm.
    run_boss = function() {

      # The API for BOSS is a bit different, so we need to handle it separately
      cat("Running BOSS algorithm...\n")
      tryCatch({
        .self$.check_score()
        suborder_search <- .jnew("edu.cmu.tetrad.search.Boss", .self$score)
        search <- .jnew("edu.cmu.tetrad.search.PermutationSearch",
                        .jcast(suborder_search, "edu.cmu.tetrad.search.SuborderSearch"))
        .self$.run_search(search)
        cat("BOSS algorithm completed. Graph generated.\n")
      }, error = function(e) {
        stop("Error during BOSS algorithm execution:", e$message, "\n")
      })

      return(.self$graph)
    },

    # Run the FCI algorithm
    #
    # @return The resulting graph from the FCI algorithm.
    run_fci = function() {
      cat("Running FCI algorithm...\n")

      tryCatch({
        .self$.check_test()
        search <- .jnew("edu.cmu.tetrad.search.Fci", .self$test)
        .self$.run_search(search)
      }, error = function(e) {
        stop("Error during FCI algorithm execution:", e$message, "\n")
      })

      return(.self$graph)
    },

    # Run the BFCI algorithm
    #
    # @return The resulting graph from the BFCI algorithm.
    run_bfci = function() {
      cat("Running BFCI algorithm...\n")

      tryCatch({
        .self$.check_score()
        .self$.check_test()
        search <- .jnew("edu.cmu.tetrad.search.BFci", .self$test, .self$score)
        .self$.run_search(search)
        cat("BFCI algorithm completed. Graph generated.\n")
      }, error = function(e) {
        stop("Error during BFCI algorithm execution:", e$message, "\n")
      })

      return(.self$graph)
    },

    # Run the LV-Lite algorithm
    #
    # @return The resulting graph from the BFCI algorithm.
    run_lvlite = function() {
      cat("Running LV-Lite algorithm...\n")

      tryCatch({
        .self$.check_score()
        .self$.check_test()
        search <- .jnew("edu.cmu.tetrad.search.LvLite", .self$test, .self$score)
        .self$.run_search(search)
        cat("LV-Lite algorithm completed. Graph generated.\n")
      }, error = function(e) {
        stop("Error during LV-Lite algorithm execution:", e$message, "\n")
      })

      return(.self$graph)
    },

    # Print the resulting graph
    #
    # This method prints the structure of the resulting graph.
    # @param graph A Tetrad graph object.
    # @return The graph object.
    print_graph = function(graph) {
      cat("Attempting to print the graph...\n")
      if (is.null(graph)) {
        cat("No graph generated yet. Please run the BOSS algorithm first.\n")
      } else {
        cat("Graph structure:\n", graph$toString(), "\n")
      }
      invisible(.self$graph)
    }
  )
)
