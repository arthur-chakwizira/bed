# bed
Biologically Effective Dose calculator for radiation therapy.

The program 'bed' accepts a radiation therapy prescription (dose per fraction
and suggested number of fractions). It allows the user to select relevant
organs at risk (OAR) for the present treatment.
__________________________________________________________________________
For each OAR, the following INPUTS can be provided by the user:
> Dose limit (as EQD2) in Gy
> alpha/beta value in Gy
> Previous irradiation (number of fractions,
dose per fraction [Gy] and percentage of dose received by OAR)
> percentage of the currently prescribed dose that the OAR will receive
__________________________________________________________________________
The OUTPUTS of the program are as follows:
> Highest possible total dose to the target
> Number of fractions in which this dose can be delivered.
> A comment highlighting whether the suggested treatment is:
  1. possible but not optimal (OAR dose limits not exceeded, but total
  dose to target less than maximum possible).
  2. possible and optimal (OAR dose limits not exceeded, and total dose to
  target is equal to maximum possible).
  3. not possible (dose limit exceeded in at least one OAR)
