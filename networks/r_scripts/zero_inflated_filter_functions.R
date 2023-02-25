##############################################################################################
# 
# Filtering function by pair of OTU prevalence 
# for abundance data and for presence /absence data
#
# INRA Theix, le 15/11/2018
# 
# Rarity of microbial species: In search of reliable associations
# PLOS ONE
# 
# Arnaud Cougoul, Xavier Bailly , Gwena?l Vourch, Patrick Gasqui
#
##############################################################################################


##############################################################################################
# Filtering function for abundance data
# otu_table: a matrix of count data with samples per row and species per column
# risk: alpha level for testability
# return a matrix whose values are equal to 1 for OTU pairs fully testable and 0 if not.


filter_by_pair <- function (otu_table, risk=0.05){
  
  prevalence = colMeans (otu_table>0)
  N = dim(otu_table)[1]
  d = dim(otu_table)[2]
  
  tt = qt(1-risk/2, N-2, lower.tail = TRUE)
  K = (tt^2)/(N-2+tt^2)
  
  f1<-function(x){(1-x)/(1+((1-K)/K)*x)}
  
  res <- matrix(0,ncol=d,nrow=d)
  for (i in 1:(d-1)){
    for (j in (i+1):d){
      if(f1(prevalence[i]) < prevalence[j]) res[i,j]<-1
    }
  } 
  
  res <- res+t(res)
  diag(res)=1
  res
}


# network making (spieceasi-like implementation with glasso)

# lambda.min.ratio = 5e-2 # ratio between min and max lambda
# l_m_r <- lambda.min.ratio
# n_lambda = 50

glasso.clr_filter <- function(dat, prefilter=T, prefilter.alpha=0.05){
  
  # clr transformation with pseudo count
  dat_clr <- log(dat+1) - rowMeans(log(dat+1))
  
  # pearson correlation matrix
  Sigma.y=cor(dat_clr,method="pearson")
  
  # rho parameter vector
  d = dim(dat_clr)[2]
  rho.max = max(max(Sigma.y-diag(d)),-min(Sigma.y-diag(d)))
  rho.min = l_m_r*rho.max
  rho = exp(seq(log(rho.max), log(rho.min), length = n_lambda))
  
  if (prefilter){
    # pairwise filter
    filter.mat <- filter_by_pair(dat, risk=prefilter.alpha)
    forced_zero <- which(filter.mat==0, arr.ind=T)
    icov <- lapply(rho, function(i) (glasso::glasso(Sigma.y, zero=forced_zero, rho=i)$wi))
  } else {
    # no filter
    icov <- lapply(rho, function(i) (glasso::glasso(Sigma.y,rho=i)$wi))
  }
  
  return(icov)
}

  
