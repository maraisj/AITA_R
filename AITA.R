#Check time when script starts
timestamp()
#Remove all variables
rm(list=ls())
#Load tidyverse. Maybe only DPLYR should be loaded as I believe only it is used
library(tidyverse)

#Set the working directory. The top commented out line can be used if the files and R file is in the same directory.
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path ))
setwd(dir = "/home/johannes/Documents/Tuks/AITA/")

#Load Files
vcitizens<- read.csv("vcitizens.csv")
vcitizentriage<- read.csv("vcitizentriage.csv")
vhouseholdassessments<- read.csv("vhouseholdassessments.csv")
vhouseholds<- read.csv("vhouseholds.csv")

#Do Selects and remove original loaded set
vcitizens_sel<-vcitizens%>%select('X_id_','lnk_household_fk','dob','age','gender','relationship','service_provider','sub_district','team','rownumber')%>%rename(citizen_id=X_id_)%>%rename(citizen_rownumber=rownumber)
rm(vcitizens)
vcitizentriage_sel<-vcitizentriage%>%select('X_id_','lnk_citizen_fk','anc_pregnant','anc_in_anc','anc_may_be_pregnant','child_neonate',
                                            'child_u5_not_immunized','emergency','emergency_description','hbc_needs_help',
                                            'hbc_gets_help','hiv_exposed','hiv_request_test','injecting_drug_use','pnc',
                                            'substance_use','substance_use_hh_support','tb_12mhx','tb_drx','tb_dx','tb_rx','tb_sx',
                                            'tb_sx_symptoms_cough','tb_sx_symptoms_fever','tb_sx_symptoms_loss_of_appetite',
                                            'tb_sx_symptoms_loss_of_weight','tb_sx_symptoms_night_sweat')%>%rename(citizentriage_id=X_id_)
rm(vcitizentriage)
vhouseholds_sel<-vhouseholds%>%select('X_id_','hh_member_count','headofhousehold_gender','headofhousehold_dob','service_provider','sub_district',
                                      'team','gps_latitude','gps_longitude','gps_accuracy','rownumber')%>%rename(household_id=X_id_)%>%rename(vhouseholds_rownumber=rownumber)
rm(vhouseholds)
vhouseholdassessments_sel<-vhouseholdassessments%>%select('X_id_','lnk_household_fk','dwellingcondition_condition','dwellingcondition_yard','dwellingtype_type',
                                                         'dwellingtype_collectivelivingtype','dwellingtype_rooms','dwellingtype_windows', 'energy_candles','energy_coal','energy_electricity','energy_gas',
                                                         'energy_is_complete','energy_paraffin','energy_solar','energy_wood','energy_other','foodsecurity_eatlessthanshould','foodsecurity_frequencymonth',
                                                         'foodsecurity_notenoughfood','foodsecurity_receivefoodparcels','foodsecurity_refertosocialservices','foodsecurity_sayshungry',
                                                         'foodsecurity_sleephungry','hhgoods_refrigerator','hhgoods_stove','toilet_handwashingfacility','toilet_is_complete',
                                                         'toilet_shared','toilet_type','toilet_where','water_pipedinhouse','water_pipedinyard','water_pipedoutsideyard','water_rainwatertank','water_springstreamriverdam',
                                                         'water_watertank','water_boreholewell','water_other','service_provider','sub_district','team','rownumber')%>%rename(householdassessment_id=X_id_)%>%rename(vhouseholdassessments_rownumber=rownumber)
rm(vhouseholdassessments)

#Do the joins 
final_set<-vhouseholds_sel %>% filter(service_provider=='Tshwane District DoH'|service_provider=='City of Tshwane') %>%
                                left_join(vhouseholdassessments_sel, by = c("household_id"="lnk_household_fk"))%>%
                                left_join(vcitizens_sel, by = c("household_id"="lnk_household_fk"))%>%
                                left_join(vcitizentriage_sel, by = c("citizen_id"="lnk_citizen_fk"))
#Write the file
write.csv(final_set,"combined.csv")
#Check time on completion
timestamp()

