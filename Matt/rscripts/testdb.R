#This short scripts tests that the db.count() object is of correct dimensions
load(file = "/home/matthew/Documents/BSPIData/rdata/samplescount.Rdata")

x <- length(samples_count[["peaks"]])
y <- length(unique(samples_count[["samples"]][["SampleID"]]))

if(x==y){
    message("SUCCESS: number of peaks matches number of samples")
    message("x:", x, " | y: ",y)
}else {
    message("ERROR: number of peaks did not match number of samples")
    message("x:", x, " | y: ",y)
}