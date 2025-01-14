#' ---
#' title: "Old Data New Analysis"
#' author: "Christine Ibilibor"
#' date: "08/20/2019"
#' ---
#' 
#+ init, message=FALSE,echo=FALSE
# init -----
if(interactive()){
  try(source('https://raw.githubusercontent.com/bokov/UT-Template/master/git_setup.R'));
};

# set to > 0 for verbose initialization
.debug <- 0;
# additional packages to install, if needed. If none needed, should be: ''
.projpackages <- c('GGally','tableone','pander')
# name of this script
.currentscript <- "data_characterization.R"; 
# other scripts which need to run before this one. If none needed, shoule be: ''
.deps <- c( 'dictionary.R' ); 

# load stuff ----
# load project-wide settings, including your personalized config.R
if(.debug>0) source('./scripts/global.R',chdir=T) else {
  .junk<-capture.output(source('./scripts/global.R',chdir=T,echo=F))};

#+ startcode, echo=F, message=FALSE
#===========================================================#
# Your code goes below, content provided only as an example #
#===========================================================#
#' ### Data Dictionary
#' 
#' Quality control, descriptive statistics, etc.

#+ characterization, echo=F, message=FALSE
# characterization ----
#' 
#' * Q: What does the command `nrow()` do?
#'     * A: It returns the number of rows that are present in your dataset. 
#'     For exmaple, my dataset has 43 rows.
#'          
#'          
#' * Q: What does the command `sample()` do? What are its first and second
#'      arguments for?
#'     * A: It returns a random sample of variables present in the specified 
#'     column. The first argument identifies the dataset from which the random
#'     sample is from and the second argument specifies the size of the sample 
#'     you want to return. For example, sample(dat00age..yr., 3) returns three
#'     different ages in the age column at random and when re-entered it returns 
#'     a different set of three random ages
#'          
#'          
#' * Q: If `foo` were a data frame, what might the expression `foo[bar,baz]` do,
#'      what are the roles of `bar` and `baz` in that expression, and what would
#'      it mean if you left either of them out of the expression?
#'     * A: foo[bar,baz] would return the data present in row named 'bar' and the 
#'     column named 'baz'. If either were left out it would return all the data 
#'     present in the data frame. 
#'          
#'          
#' 
dct0$column <- make.unique(unlist(submulti(dct0$column,map0,method='exact')));
names(dat00) <-dct0$column;

for(ii in v(c_ordinal)) {dat00[[ii]] <- as.factor (dat00[,ii])}

set.seed(project_seed);
dat01 <- dat00[sample(nrow(dat00), nrow(dat00)/2),];



set.caption('Data Dictionary');
set.alignment(row.names='right');
.oldopt00 <- panderOptions('table.continues');
panderOptions('table.continues','Data Dictionary (continued)');
#  render the Data Dictionary table
pander(dct0[,-1],row.names=dct0$column,split.tables=Inf); 
#  reset this option to its previous value
panderOptions('table.continues',.oldopt00);

#' ### Select predictor and outcome variables
#' 
#' Predictors
predictorvars <- c('retained', 'duration');
#' Outcomes
outcomevars <- c('Dx_CKD_removal', 'Dx_CKD_3mo');
#' All analysis-ready variables
mainvars <- c(outcomevars, predictorvars);

#' ### Scatterplot matrix)
#' 
#' To explore pairwise relationships between all variables of interest.
#+ ggpairs_plot, message=FALSE, warning=FALSE
ggpairs(dat00[,mainvars])

#' ### Cohort Characterization
#' 
#Q: Which function 'owns' the argument `caption`? What value does that 
#'      argument pass to that function?
#'     * A: the function 'print' owns the argument 'caption' and that argument passes
#'     the value 'Cohort Characterization' to the function print
#'          
#'          
#' * Q: Which function 'owns' the argument `printToggle`? What value does that 
#'      argument pass to that function?
#'     * A: The function CreateTableOne owns the argument 'printToggle' and the argument 'printToggle' passes
#'     the value of oriententing the table characters and values in the center or left alignment depending
#'     on if TRUE or FALSE is used. 'printToggle=TRUE' creates left-alignment
#'          
#'          
#' * Q: Which function 'owns' the argument `vars`? We can see that the value
#'      this argument passes comes from the variable `mainvars`... so what is
#'      the actual value that ends up getting passed to the function?
#'     * A: The function 'CreateTableOne' owns the argument 'vars'. The value that gets passed
#'     to the function CreateTableOne is the values present in the 'mainvars' columns
#'          
#'          
#' * Q: What is the _very first_ argument of `print()` in the expression below?
#'      (copy-paste only that argument into your answer without including 
#'      anything extra)
#'     * A: CreateTableOne(vars = mainvars, data = dat01, includeNA = TRUE
#'          
#'          
#' To explore possible covariates
pander(print(CreateTableOne(vars = mainvars, data = dat01, includeNA = TRUE)
             , printToggle=FALSE)
       , caption='Cohort Characterization');

#' ### Data Analysis
#' 
#' Fitting the actual statistical models.
#+ echo=FALSE, message=FALSE
# analysis ----

#+ echo=FALSE,warning=FALSE,message=FALSE
#===========================================================#
##### End of your code, start of boilerplate code ###########
#===========================================================#
knitr::opts_chunk$set(echo = FALSE,warning = FALSE,message=FALSE);

# save out with audit trail ----
message('About to tsave');
tsave(file=paste0(.currentscript,'.rdata'),list=setdiff(ls(),.origfiles)
      ,verbose=FALSE);
message('Done tsaving');

#' ### Audit Trail
.wt <- walktrail();
c()
