#
# Example taken from Parallelize R code on a Slurm cluster
# (https://cran.microsoft.com/snapshot/2022-04-01/web/packages/rslurm/vignettes/rslurm.html)
#

if (!require('rslurm')) install.packages('rslurm', lib=.libPaths()[1], repos='http://cran.r-project.org')

test_func <- function(par_mu, par_sd) {
    samp <- rnorm(10^6, par_mu, par_sd)
    c(s_mu = mean(samp), s_sd = sd(samp))
}

pars <- data.frame(par_mu = 1:10,
                   par_sd = seq(0.1, 1, length.out = 10))
head(pars, 3)

library(rslurm)
sjob <- slurm_apply(test_func, pars, jobname = 'test_apply',
                    nodes = 2, cpus_per_node = 2, submit = TRUE)

res <- get_slurm_out(sjob, outtype = 'table', wait = TRUE)
head(res, 3)
