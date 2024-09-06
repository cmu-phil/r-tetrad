# ----- Main Script -----
source("R/tetrad_utils.R")
source("R/TetradSearch.R")

# Install required packages
required_packages <- c("rJava", "DiagrammeR")
ensure_packages_installed(required_packages)

# Setup Java and Tetrad
setup_tetrad_environment()

# Load and prepare data
data_file <- "data/airfoil-self-noise.continuous.txt"
data <- read.table(data_file, header = TRUE)
continuous_columns <- c(1, ncol(data))
data[, continuous_columns] <- apply(data[, continuous_columns], 2, as.numeric)

# Create a TetradSearch object with the data
ts <- TetradSearch$new(data)

# Optionally, add knowledge to specific tiers
ts$add_to_tier(1, "Velocity")
ts$add_to_tier(1, "Chord")
ts$add_to_tier(1, "Attack")
ts$add_to_tier(2, "Frequency")
ts$add_to_tier(2, "Displacement")
ts$add_to_tier(2, "Pressure")

# Run the BOSS algorithm
ts$use_sem_bic(penalty_discount = 2)
ts$use_fisher_z(alpha = 0.01)
graph <- ts$run_boss()
ts$print_graph(graph)

# Visualize the resulting graph if in RStudio
visualize_graph(graph)
