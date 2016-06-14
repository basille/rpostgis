# pgInsertize
#' Formats an R data frame for insert into a PostgreSQL table (for use with pgInsert)
#
#' @title Formats an R data frame for insert into a PostgreSQL table (for use with pgInsert)
#'
#' @param df A data frame
#' @param force.match character, schema and table of the PostgreSQL table to compare columns of data frame with 
#' If specified, only columns in the data frame that exactly match the database table will be kept, and reordered
#' to match the database table. If NULL, all columns will be kept in the same order given in the data frame.
#' @param conn A database connection (required if a table is given in for "force.match" parameter)
#' @author David Bucklin \email{david.bucklin@gmail.com}
#' @export
#' @return List containing two character strings- (1) db.cols.insert, a character string of the database column
#' names to make inserts on, and (2) insert.data, a character string of the data to insert. See examples for 
#' usage within the \code{pgInsert} function.
#' @examples
#' 
#' \dontrun{
#' #connect to database
#' library(RPostgreSQL)
#' drv<-dbDriver("PostgreSQL")
#' conn<-dbConnect(drv,dbname='dbname',host='host',port='5432',
#'                user='user',password='password')
#' }
#' 
#' data<-data.frame(a=c(1,2,3),b=c(4,NA,6),c=c(7,'text',9))
#' 
#' #format all columns for insert
#' values<-pgInsertize(df=data)
#' 
#' \dontrun{
#' # insert data in database table (note that an error will be given if all insert columns 
#' # do not match exactly to database table columns)
#' pgInsert(conn,c("schema","table"),pgi=values)
#' 
#' ##
#' #run with forced matching of database table column names
#' values<-pgInsertize(df=data,force.match=c("schema","table"),conn=conn)
#' 
#' pgInsert(conn,c("schema","table"),pgi=values)
#' }

pgInsertize <- function(df,force.match=NULL,conn=NULL) {
  
  rcols<-colnames(df)
  
  if (!is.null(force.match)) {
    
    if(length(force.match) == 1) {force.match[2]<-force.match
                                  force.match[1]<-"public"}
    
    db.cols<-pgColumnInfo(conn,name=(c(force.match[1],force.match[2])))$column_name
    
    db.cols.match<-db.cols[!is.na(match(db.cols,rcols))]
    db.cols.insert<-db.cols.match
    
    #reorder data frame columns
    df<-df[db.cols.match]
    
    message(paste0(length(colnames(df))," out of ",length(rcols)," columns of the data frame match database table columns and will be formatted for database insert."))

  } else {
    db.cols.insert<-rcols
  }
  
  #set NA to user-specified NULL value
  df[] <- lapply(df, as.character)
  df[is.na(df)]<-"NULL"
  
  #format rows of data frame
  d1<-apply(df,1,function(x) paste0("('",toString(paste(gsub("'","''",x,fixed=TRUE),collapse="','")),"')"))
  d1<-gsub("'NULL'","NULL",d1)
  d1<-paste(d1,collapse=",")
  
  lis<-list(db.cols.insert=db.cols.insert,insert.data=d1)
  class(lis)<-"pgi"
  
  return(lis)
}

#default print
print.pgi <- function(x) {
  cat(paste0("Columns to insert into: ",paste(x$db.cols.insert,collapse=",")))
  cat('\n')
  cat(paste0("Insert data: ",substr(x$insert.data,0,1000)))
  if(nchar(x$insert.data) > 1000) {cat("...Only the first 1000 characters shown")}
}