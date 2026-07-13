Report 50277 "Consolidated Marksheet A3"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ConsolidatedMarksheetA3.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Course Registration"; "Course Registration")
        {
            DataItemTableView = sorting("Student No.") order(ascending) where(Reversed = const(false), "Cust Exist" = filter(> 0), "Graduated List Count" = filter(0), "Current Sem" = const(false), Status = filter(Current | Registration | Suspended), "CF Total Score" = filter(> 0));
            RequestFilterFields = "Programme Filter", "Stage Filter", "Semester Filter", "Academic Year", "Options Filter", "Student No.";
            column(ReportForNavId_2901; 2901) { }
            column(SemYear; SemYear) { }
            column(Course_Registration__GETFILTER__Course_Registration___Stage_Filter__; "Course Registration".GetFilter("Course Registration"."Stage Filter")) { }
            column(Options_CourseRegistration; "Course Registration".Options) { }
            column(PName; PName) { }
            column(Dept; Dept) { }
            column(FDesc; FDesc) { }
            column(Logo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(UnitNo; UnitNo) { }
            column(YearDesc; YearDesc) { }
            column(COMPANYNAME; COMPANYNAME) { }

            column(Course_Registration__GETFILTER__Course_Registration___Semester_Filter__; "Course Registration".GetFilter("Course Registration"."Semester Filter")) { }
            column(Course_Registration__GETFILTER__Course_Registration___Campus_Filter__; "Course Registration".GetFilter("Course Registration"."Campus Filter")) { }
            column(ColumnH2_1_; ColumnH2[1]) { }
            column(ColumnH2_8_; ColumnH2[8]) { }
            column(ColumnH2_6_; ColumnH2[6]) { }
            column(ColumnH2_7_; ColumnH2[7]) { }
            column(ColumnH2_4_; ColumnH2[4]) { }
            column(ColumnH2_3_; ColumnH2[3]) { }
            column(ColumnH2_5_; ColumnH2[5]) { }
            column(ColumnH2_2_; ColumnH2[2]) { }
            column(ColumnH2_9_; ColumnH2[9]) { }
            column(ColumnH2_10_; ColumnH2[10]) { }
            column(ColumnH2_11_; ColumnH2[11]) { }
            column(ColumnH2_12_; ColumnH2[12]) { }
            column(ColumnH2_13_; ColumnH2[13]) { }
            column(ColumnH2_14_; ColumnH2[14]) { }
            column(ColumnH2_15_; ColumnH2[15]) { }
            column(ColumnH2_16_; ColumnH2[16]) { }
            column(ColumnH2_17_; ColumnH2[17]) { }
            column(ColumnH2_18_; ColumnH2[18]) { }
            column(ColumnH2_19_; ColumnH2[19]) { }
            column(ColumnH2_20_; ColumnH2[20]) { }
            column(ColumnH2_21_; ColumnH2[21]) { }
            column(ColumnH_1_; ColumnH[1]) { }
            column(ColumnH_8_; ColumnH[8]) { }
            column(ColumnH_6_; ColumnH[6]) { }
            column(ColumnH_7_; ColumnH[7]) { }
            column(ColumnH_4_; ColumnH[4]) { }
            column(ColumnH_3_; ColumnH[3]) { }
            column(ColumnH_5_; ColumnH[5]) { }
            column(ColumnH_2_; ColumnH[2]) { }
            column(ColumnH_15_; ColumnH[15]) { }
            column(ColumnH_14_; ColumnH[14]) { }
            column(ColumnH_13_; ColumnH[13]) { }
            column(ColumnH_12_; ColumnH[12]) { }
            column(ColumnH_10_; ColumnH[10]) { }
            column(ColumnH_9_; ColumnH[9]) { }
            column(ColumnH_11_; ColumnH[11]) { }
            column(ColumnH_23_; ColumnH[23]) { }
            column(ColumnH_22_; ColumnH[22]) { }
            column(ColumnH_21_; ColumnH[21]) { }
            column(ColumnH_20_; ColumnH[20]) { }
            column(ColumnH_19_; ColumnH[19]) { }
            column(ColumnH_18_; ColumnH[18]) { }
            column(ColumnH_17_; ColumnH[17]) { }
            column(ColumnH_16_; ColumnH[16]) { }
            column(uColumnV_1_; uColumnV[1]) { }
            column(uColumnV_2_; uColumnV[2]) { }
            column(uColumnV_3_; uColumnV[3]) { }
            column(uColumnV_4_; uColumnV[4]) { }
            column(uColumnV_5_; uColumnV[5]) { }
            column(uColumnV_6_; uColumnV[6]) { }
            column(uColumnV_7_; uColumnV[7]) { }
            column(uColumnV_8_; uColumnV[8]) { }
            column(uColumnV_9_; uColumnV[9]) { }
            column(uColumnV_10_; uColumnV[10]) { }
            column(uColumnV_11_; uColumnV[11]) { }
            column(uColumnV_12_; uColumnV[12]) { }
            column(uColumnV_13_; uColumnV[13]) { }
            column(uColumnV_14_; uColumnV[14]) { }
            column(uColumnV_15_; uColumnV[15]) { }
            column(uColumnV_16_; uColumnV[16]) { }
            column(uColumnV_17_; uColumnV[17]) { }
            column(uColumnV_18_; uColumnV[18]) { }
            column(uColumnV_19_; uColumnV[19]) { }
            column(uColumnV_20_; uColumnV[20]) { }
            column(uColumnV_21_; uColumnV[21]) { }
            column(uColumnV_22_; uColumnV[22]) { }
            column(uColumnV_23_; uColumnV[23]) { }
            column(uColumnV_30_; uColumnV[30]) { }
            column(uColumnV_29_; uColumnV[29]) { }
            column(uColumnV_28_; uColumnV[28]) { }
            column(ColumnH_26_; ColumnH[26]) { }
            column(ColumnH_30_; ColumnH[30]) { }
            column(ColumnH_29_; ColumnH[29]) { }
            column(ColumnH_28_; ColumnH[28]) { }
            column(uColumnV_27_; uColumnV[27]) { }
            column(ColumnH_27_; ColumnH[27]) { }
            column(uColumnV_26_; uColumnV[26]) { }
            column(ColumnH_25_; ColumnH[25]) { }
            column(uColumnV_25_; uColumnV[25]) { }
            column(ColumnH_24_; ColumnH[24]) { }
            column(uColumnV_24_; uColumnV[24]) { }
            column(ColumnH_31_; ColumnH[31]) { }
            column(ColumnH_40_; ColumnH[40]) { }
            column(ColumnH_39_; ColumnH[39]) { }
            column(ColumnH_38_; ColumnH[38]) { }
            column(ColumnH_45_; ColumnH[45]) { }
            column(ColumnH_37_; ColumnH[37]) { }
            column(uColumnV_45_; uColumnV[45]) { }
            column(uColumnV_40_; uColumnV[40]) { }
            column(uColumnV_39_; uColumnV[39]) { }
            column(uColumnV_38_; uColumnV[38]) { }
            column(uColumnV_37_; uColumnV[37]) { }
            column(ColumnH_36_; ColumnH[36]) { }
            column(uColumnV_36_; uColumnV[36]) { }
            column(ColumnH_35_; ColumnH[35]) { }
            column(uColumnV_35_; uColumnV[35]) { }
            column(ColumnH_34_; ColumnH[34]) { }
            column(uColumnV_34_; uColumnV[34]) { }
            column(ColumnH_33_; ColumnH[33]) { }
            column(uColumnV_33_; uColumnV[33]) { }
            column(ColumnH_32_; ColumnH[32]) { }
            column(uColumnV_32_; uColumnV[32]) { }
            column(uColumnV_31_; uColumnV[31]) { }
            column(ColumnH_41_; ColumnH[41]) { }
            column(ColumnH_50_; ColumnH[50]) { }
            column(ColumnH_49_; ColumnH[49]) { }
            column(ColumnH_48_; ColumnH[48]) { }
            column(ColumnH_47_; ColumnH[47]) { }
            column(uColumnV_50_; uColumnV[50]) { }
            column(uColumnV_49_; uColumnV[49]) { }
            column(uColumnV_48_; uColumnV[48]) { }
            column(uColumnV_47_; uColumnV[47]) { }
            column(ColumnH_46_; ColumnH[46]) { }
            column(uColumnV_46_; uColumnV[46]) { }
            column(ColumnH_25__Control1102755076; ColumnH[25]) { }
            column(ColumnH_44_; ColumnH[44]) { }
            column(uColumnV_44_; uColumnV[44]) { }
            column(ColumnH_43_; ColumnH[43]) { }
            column(uColumnV_43_; uColumnV[43]) { }
            column(ColumnH_42_; ColumnH[42]) { }
            column(uColumnV_42_; uColumnV[42]) { }
            column(uColumnV_41_; uColumnV[41]) { }
            column(ColumnH_51_; ColumnH[51]) { }
            column(ColumnH_60_; ColumnH[60]) { }
            column(ColumnH_59_; ColumnH[59]) { }
            column(ColumnH_58_; ColumnH[58]) { }
            column(ColumnH_57_; ColumnH[57]) { }
            column(uColumnV_60_; uColumnV[60]) { }
            column(uColumnV_59_; uColumnV[59]) { }
            column(uColumnV_58_; uColumnV[58]) { }
            column(uColumnV_57_; uColumnV[57]) { }
            column(ColumnH_56_; ColumnH[56]) { }
            column(uColumnV_56_; uColumnV[56]) { }
            column(ColumnH_55_; ColumnH[55]) { }
            column(uColumnV_55_; uColumnV[55]) { }
            column(ColumnH_54_; ColumnH[54]) { }
            column(uColumnV_54_; uColumnV[54]) { }
            column(ColumnH_53_; ColumnH[53]) { }
            column(uColumnV_53_; uColumnV[53]) { }
            column(ColumnH_22__Control1102755102; ColumnH[22]) { }
            column(uColumnV_52_; uColumnV[52]) { }
            column(uColumnV_51_; uColumnV[51]) { }
            column(ColumnH_66_; ColumnH[66]) { }
            column(uColumnV_66_; uColumnV[66]) { }
            column(ColumnH_65_; ColumnH[65]) { }
            column(uColumnV_65_; uColumnV[65]) { }
            column(ColumnH_64_; ColumnH[64]) { }
            column(uColumnV_64_; uColumnV[64]) { }
            column(ColumnH_63_; ColumnH[63]) { }
            column(uColumnV_63_; uColumnV[63]) { }
            column(ColumnH_62_; ColumnH[62]) { }
            column(uColumnV_62_; uColumnV[62]) { }
            column(ColumnH_61_; ColumnH[61]) { }
            column(uColumnV_61_; uColumnV[61]) { }
            column(Course_Registration___Student_No___FORMAT__Course_Registration___Marks_Status__; "Course Registration"."Student No.") { }
            column(Cust_Name; Cust.Name) { }
            column(ColumnV_1_; ColumnV[1]) { }
            column(ColumnV_8_; ColumnV[8]) { }
            column(ColumnV_7_; ColumnV[7]) { }
            column(ColumnV_6_; ColumnV[6]) { }
            column(ColumnV_5_; ColumnV[5]) { }
            column(ColumnV_4_; ColumnV[4]) { }
            column(ColumnV_3_; ColumnV[3]) { }
            column(ColumnV_2_; ColumnV[2]) { }
            column(ColumnV_14_; ColumnV[14]) { }
            column(ColumnV_13_; ColumnV[13]) { }
            column(ColumnV_12_; ColumnV[12]) { }
            column(ColumnV_11_; ColumnV[11]) { }
            column(ColumnV_10_; ColumnV[10]) { }
            column(ColumnV_9_; ColumnV[9]) { }
            column(ColumnV_23_; ColumnV[23]) { }
            column(ColumnV_22_; ColumnV[22]) { }
            column(ColumnV_21_; ColumnV[21]) { }
            column(ColumnV_20_; ColumnV[20]) { }
            column(ColumnV_19_; ColumnV[19]) { }
            column(ColumnV_18_; ColumnV[18]) { }
            column(ColumnV_17_; ColumnV[17]) { }
            column(ColumnV_16_; ColumnV[16]) { }
            column(ColumnV_15_; ColumnV[15]) { }
            column(SCount; SCount) { }
            column(ColumnV_30_; ColumnV[30]) { }
            column(ColumnV_29_; ColumnV[29]) { }
            column(ColumnV_28_; ColumnV[28]) { }
            column(ColumnV_27_; ColumnV[27]) { }
            column(ColumnV_26_; ColumnV[26]) { }
            column(ColumnV_25_; ColumnV[25]) { }
            column(ColumnV_24_; ColumnV[24]) { }
            column(ColumnV_60_; ColumnV[60]) { }
            column(ColumnV_59_; ColumnV[59]) { }
            column(ColumnV_58_; ColumnV[58]) { }
            column(ColumnV_57_; ColumnV[57]) { }
            column(ColumnV_56_; ColumnV[56]) { }
            column(ColumnV_55_; ColumnV[55]) { }
            column(ColumnV_54_; ColumnV[54]) { }
            column(ColumnV_53_; ColumnV[53]) { }
            column(ColumnV_52_; ColumnV[52]) { }
            column(ColumnV_51_; ColumnV[51]) { }
            column(ColumnV_50_; ColumnV[50]) { }
            column(ColumnV_49_; ColumnV[49]) { }
            column(ColumnV_48_; ColumnV[48]) { }
            column(ColumnV_47_; ColumnV[47]) { }
            column(ColumnV_46_; ColumnV[46]) { }
            column(ColumnV_45_; ColumnV[45]) { }
            column(ColumnV_44_; ColumnV[44]) { }
            column(ColumnV_43_; ColumnV[43]) { }
            column(ColumnV_42_; ColumnV[42]) { }
            column(ColumnV_41_; ColumnV[41]) { }
            column(ColumnV_40_; ColumnV[40]) { }
            column(ColumnV_39_; ColumnV[39]) { }
            column(ColumnV_38_; ColumnV[38]) { }
            column(ColumnV_37_; ColumnV[37]) { }
            column(ColumnV_36_; ColumnV[36]) { }
            column(ColumnV_35_; ColumnV[35]) { }
            column(ColumnV_34_; ColumnV[34]) { }
            column(ColumnV_33_; ColumnV[33]) { }
            column(ColumnV_32_; ColumnV[32]) { }
            column(ColumnV_31_; ColumnV[31]) { }
            column(ColumnV_65_; ColumnV[65]) { }
            column(ColumnV_64_; ColumnV[64]) { }
            column(ColumnV_63_; ColumnV[63]) { }
            column(ColumnV_62_; ColumnV[62]) { }
            column(ColumnV_61_; ColumnV[61]) { }
            column(ColumnV_66_; ColumnV[66]) { }
            column(ColumnUN_24_; ColumnUN[24]) { }
            column(ColumnUN_23_; ColumnUN[23]) { }
            column(ColumnUN_21_; ColumnUN[21]) { }
            column(ColumnUN_22_; ColumnUN[22]) { }
            column(ColumnUN_19_; ColumnUN[19]) { }
            column(ColumnUN_20_; ColumnUN[20]) { }
            column(ColumnUN_18_; ColumnUN[18]) { }
            column(ColumnUN_17_; ColumnUN[17]) { }
            column(ColumnUN_12_; ColumnUN[12]) { }
            column(ColumnUN_11_; ColumnUN[11]) { }
            column(ColumnUN_10_; ColumnUN[10]) { }
            column(ColumnUN_9_; ColumnUN[9]) { }
            column(ColumnUN_16_; ColumnUN[16]) { }
            column(ColumnUN_15_; ColumnUN[15]) { }
            column(ColumnUN_14_; ColumnUN[14]) { }
            column(ColumnUN_13_; ColumnUN[13]) { }
            column(ColumnUN_1_; ColumnUN[1]) { }
            column(ColumnUN_2_; ColumnUN[2]) { }
            column(ColumnUN_4_; ColumnUN[4]) { }
            column(ColumnUN_3_; ColumnUN[3]) { }
            column(ColumnUN_6_; ColumnUN[6]) { }
            column(ColumnUN_5_; ColumnUN[5]) { }
            column(ColumnUN_7_; ColumnUN[7]) { }
            column(ColumnUN_8_; ColumnUN[8]) { }
            column(GenSetup__Cons__Marksheet_Key2_; GenSetup."Cons. Marksheet Key2") { }
            column(GenSetup__Cons__Marksheet_Key1_; GenSetup."Cons. Marksheet Key1") { }
            column(Dean___FDesc; 'Dean ' + FDesc) { }
            column(TReg; TReg) { }
            column(SMM_1_; SMM[1]) { }
            column(ColumnVA_1_; ColumnVA[1]) { }
            column(ColumnVA_2_; ColumnVA[2]) { }
            column(ColumnVA_3_; ColumnVA[3]) { }
            column(ColumnVA_4_; ColumnVA[4]) { }
            column(ColumnVA_5_; ColumnVA[5]) { }
            column(ColumnVA_6_; ColumnVA[6]) { }
            column(ColumnVA_7_; ColumnVA[7]) { }
            column(ColumnVA_8_; ColumnVA[8]) { }
            column(ColumnVA_9_; ColumnVA[9]) { }
            column(ColumnVA_10_; ColumnVA[10]) { }
            column(ColumnVA_11_; ColumnVA[11]) { }
            column(ColumnVA_12_; ColumnVA[12]) { }
            column(ColumnVA_13_; ColumnVA[13]) { }
            column(ColumnVA_14_; ColumnVA[14]) { }
            column(ColumnVA_15_; ColumnVA[15]) { }
            column(ColumnVA_16_; ColumnVA[16]) { }
            column(ColumnVA_17_; ColumnVA[17]) { }
            column(ColumnVA_18_; ColumnVA[18]) { }
            column(ColumnVA_19_; ColumnVA[19]) { }
            column(ColumnVA_20_; ColumnVA[20]) { }
            column(ColumnVA_21_; ColumnVA[21]) { }
            column(ColumnVA_22_; ColumnVA[22]) { }
            column(ColumnVA_23_; ColumnVA[23]) { }
            column(ColumnVA_24_; ColumnVA[24]) { }
            column(ColumnVA_25_; ColumnVA[25]) { }
            column(ColumnVA_26_; ColumnVA[26]) { }
            column(ColumnVA_27_; ColumnVA[27]) { }
            column(ColumnVA_28_; ColumnVA[28]) { }
            column(ColumnVA_29_; ColumnVA[29]) { }
            column(ColumnVA_30_; ColumnVA[30]) { }
            column(ColumnVA_31_; ColumnVA[31]) { }
            column(ColumnVA_32_; ColumnVA[32]) { }
            column(ColumnVA_33_; ColumnVA[33]) { }
            column(ColumnVA_34_; ColumnVA[34]) { }
            column(ColumnVA_35_; ColumnVA[35]) { }
            column(ColumnVA_36_; ColumnVA[36]) { }
            column(ColumnVA_37_; ColumnVA[37]) { }
            column(ColumnVA_38_; ColumnVA[38]) { }
            column(ColumnVA_39_; ColumnVA[39]) { }
            column(ColumnVA_40_; ColumnVA[40]) { }
            column(ColumnVA_41_; ColumnVA[41]) { }
            column(ColumnVA_42_; ColumnVA[42]) { }
            column(ColumnVA_43_; ColumnVA[43]) { }
            column(ColumnVA_44_; ColumnVA[44]) { }
            column(ColumnVA_45_; ColumnVA[45]) { }
            column(ColumnVA_46_; ColumnVA[46]) { }
            column(ColumnVA_47_; ColumnVA[47]) { }
            column(ColumnVA_48_; ColumnVA[48]) { }
            column(ColumnVA_49_; ColumnVA[49]) { }
            column(ColumnVA_50_; ColumnVA[50]) { }
            column(ColumnVA_51_; ColumnVA[51]) { }
            column(ColumnVA_52_; ColumnVA[52]) { }
            column(ColumnVA_53_; ColumnVA[53]) { }
            column(ColumnVA_54_; ColumnVA[54]) { }
            column(ColumnVA_55_; ColumnVA[55]) { }
            column(ColumnVA_56_; ColumnVA[56]) { }
            column(ColumnVA_57_; ColumnVA[57]) { }
            column(ColumnVA_58_; ColumnVA[58]) { }
            column(ColumnVA_59_; ColumnVA[59]) { }
            column(ColumnVA_60_; ColumnVA[60]) { }
            column(ColumnVA_61_; ColumnVA[61]) { }
            column(ColumnVA_62_; ColumnVA[62]) { }
            column(ColumnVA_63_; ColumnVA[63]) { }
            column(ColumnVA_64_; ColumnVA[64]) { }
            column(ColumnVA_65_; ColumnVA[65]) { }
            column(ColumnVA_66_; ColumnVA[66]) { }
            column(ColumnVM_1_; ColumnVM[1]) { }
            column(ColumnVM_2_; ColumnVM[2]) { }
            column(ColumnVM_3_; ColumnVM[3]) { }
            column(ColumnVM_4_; ColumnVM[4]) { }
            column(ColumnVM_5_; ColumnVM[5]) { }
            column(ColumnVM_6_; ColumnVM[6]) { }
            column(ColumnVM_7_; ColumnVM[7]) { }
            column(ColumnVM_8_; ColumnVM[8]) { }
            column(ColumnVM_9_; ColumnVM[9]) { }
            column(ColumnVM_10_; ColumnVM[10]) { }
            column(ColumnVM_11_; ColumnVM[11]) { }
            column(ColumnVM_12_; ColumnVM[12]) { }
            column(ColumnVM_13_; ColumnVM[13]) { }
            column(ColumnVM_14_; ColumnVM[14]) { }
            column(ColumnVM_15_; ColumnVM[15]) { }
            column(ColumnVM_16_; ColumnVM[16]) { }
            column(ColumnVM_17_; ColumnVM[17]) { }
            column(ColumnVM_18_; ColumnVM[18]) { }
            column(ColumnVM_19_; ColumnVM[19]) { }
            column(ColumnVM_20_; ColumnVM[20]) { }
            column(ColumnVM_21_; ColumnVM[21]) { }
            column(ColumnVM_22_; ColumnVM[22]) { }
            column(ColumnVM_23_; ColumnVM[23]) { }
            column(ColumnVM_24_; ColumnVM[24]) { }
            column(ColumnVM_25_; ColumnVM[25]) { }
            column(ColumnVM_26_; ColumnVM[26]) { }
            column(ColumnVM_27_; ColumnVM[27]) { }
            column(ColumnVM_28_; ColumnVM[28]) { }
            column(ColumnVM_29_; ColumnVM[29]) { }
            column(ColumnVM_30_; ColumnVM[30]) { }
            column(ColumnVM_31_; ColumnVM[31]) { }
            column(ColumnVM_32_; ColumnVM[32]) { }
            column(ColumnVM_33_; ColumnVM[33]) { }
            column(ColumnVM_34_; ColumnVM[34]) { }
            column(ColumnVM_35_; ColumnVM[35]) { }
            column(ColumnVM_36_; ColumnVM[36]) { }
            column(ColumnVM_37_; ColumnVM[37]) { }
            column(ColumnVM_38_; ColumnVM[38]) { }
            column(ColumnVM_39_; ColumnVM[39]) { }
            column(ColumnVM_40_; ColumnVM[40]) { }
            column(ColumnVM_41_; ColumnVM[41]) { }
            column(ColumnVM_42_; ColumnVM[42]) { }
            column(ColumnVM_43_; ColumnVM[43]) { }
            column(ColumnVM_44_; ColumnVM[44]) { }
            column(ColumnVM_45_; ColumnVM[45]) { }
            column(ColumnVM_46_; ColumnVM[46]) { }
            column(ColumnVM_47_; ColumnVM[47]) { }
            column(ColumnVM_48_; ColumnVM[48]) { }
            column(ColumnVM_49_; ColumnVM[49]) { }
            column(ColumnVM_50_; ColumnVM[50]) { }
            column(ColumnVM_51_; ColumnVM[51]) { }
            column(ColumnVM_52_; ColumnVM[52]) { }
            column(ColumnVM_53_; ColumnVM[53]) { }
            column(ColumnVM_54_; ColumnVM[54]) { }
            column(ColumnVM_55_; ColumnVM[55]) { }
            column(ColumnVM_56_; ColumnVM[56]) { }
            column(ColumnVM_57_; ColumnVM[57]) { }
            column(ColumnVM_58_; ColumnVM[58]) { }
            column(ColumnVM_59_; ColumnVM[59]) { }
            column(ColumnVM_60_; ColumnVM[60]) { }
            column(ColumnVM_61_; ColumnVM[61]) { }
            column(ColumnVM_62_; ColumnVM[62]) { }
            column(ColumnVM_63_; ColumnVM[63]) { }
            column(ColumnVM_64_; ColumnVM[64]) { }
            column(ColumnVM_65_; ColumnVM[65]) { }
            column(ColumnVM_66_; ColumnVM[66]) { }
            column(ColumnVX_1_; ColumnVX[1]) { }
            column(ColumnVX_2_; ColumnVX[2]) { }
            column(ColumnVX_3_; ColumnVX[3]) { }
            column(ColumnVX_4_; ColumnVX[4]) { }
            column(ColumnVX_5_; ColumnVX[5]) { }
            column(ColumnVX_6_; ColumnVX[6]) { }
            column(ColumnVX_7_; ColumnVX[7]) { }
            column(ColumnVX_8_; ColumnVX[8]) { }
            column(ColumnVX_9_; ColumnVX[9]) { }
            column(ColumnVX_10_; ColumnVX[10]) { }
            column(ColumnVX_11_; ColumnVX[11]) { }
            column(ColumnVX_12_; ColumnVX[12]) { }
            column(ColumnVX_13_; ColumnVX[13]) { }
            column(ColumnVX_14_; ColumnVX[14]) { }
            column(ColumnVX_15_; ColumnVX[15]) { }
            column(ColumnVX_16_; ColumnVX[16]) { }
            column(ColumnVX_17_; ColumnVX[17]) { }
            column(ColumnVX_18_; ColumnVX[18]) { }
            column(ColumnVX_19_; ColumnVX[19]) { }
            column(ColumnVX_20_; ColumnVX[20]) { }
            column(ColumnVX_21_; ColumnVX[21]) { }
            column(ColumnVX_22_; ColumnVX[22]) { }
            column(ColumnVX_23_; ColumnVX[23]) { }
            column(ColumnVX_24_; ColumnVX[24]) { }
            column(ColumnVX_25_; ColumnVX[25]) { }
            column(ColumnVX_26_; ColumnVX[26]) { }
            column(ColumnVX_27_; ColumnVX[27]) { }
            column(ColumnVX_28_; ColumnVX[28]) { }
            column(ColumnVX_29_; ColumnVX[29]) { }
            column(ColumnVX_30_; ColumnVX[30]) { }
            column(ColumnVX_31_; ColumnVX[31]) { }
            column(ColumnVX_32_; ColumnVX[32]) { }
            column(ColumnVX_33_; ColumnVX[33]) { }
            column(ColumnVX_34_; ColumnVX[34]) { }
            column(ColumnVX_35_; ColumnVX[35]) { }
            column(ColumnVX_36_; ColumnVX[36]) { }
            column(ColumnVX_37_; ColumnVX[37]) { }
            column(ColumnVX_38_; ColumnVX[38]) { }
            column(ColumnVX_39_; ColumnVX[39]) { }
            column(ColumnVX_40_; ColumnVX[40]) { }
            column(ColumnVX_41_; ColumnVX[41]) { }
            column(ColumnVX_42_; ColumnVX[42]) { }
            column(ColumnVX_43_; ColumnVX[43]) { }
            column(ColumnVX_44_; ColumnVX[44]) { }
            column(ColumnVX_45_; ColumnVX[45]) { }
            column(ColumnVX_46_; ColumnVX[46]) { }
            column(ColumnVX_47_; ColumnVX[47]) { }
            column(ColumnVX_48_; ColumnVX[48]) { }
            column(ColumnVX_49_; ColumnVX[49]) { }
            column(ColumnVX_50_; ColumnVX[50]) { }
            column(ColumnVX_51_; ColumnVX[51]) { }
            column(ColumnVX_52_; ColumnVX[52]) { }
            column(ColumnVX_53_; ColumnVX[53]) { }
            column(ColumnVX_54_; ColumnVX[54]) { }
            column(ColumnVX_55_; ColumnVX[55]) { }
            column(ColumnVX_56_; ColumnVX[56]) { }
            column(ColumnVX_57_; ColumnVX[57]) { }
            column(ColumnVX_58_; ColumnVX[58]) { }
            column(ColumnVX_59_; ColumnVX[59]) { }
            column(ColumnVX_60_; ColumnVX[60]) { }
            column(ColumnVX_61_; ColumnVX[61]) { }
            column(ColumnVX_62_; ColumnVX[62]) { }
            column(ColumnVX_63_; ColumnVX[63]) { }
            column(ColumnVX_64_; ColumnVX[64]) { }
            column(ColumnVX_65_; ColumnVX[65]) { }
            column(ColumnVX_66_; ColumnVX[66]) { }
            column(ColumnUN_24__Control1102755385; ColumnUN[24]) { }
            column(ColumnUN_23__Control1102755386; ColumnUN[23]) { }
            column(ColumnUN_21__Control1102755387; ColumnUN[21]) { }
            column(ColumnUN_22__Control1102755388; ColumnUN[22]) { }
            column(ColumnUN_19__Control1102755389; ColumnUN[19]) { }
            column(ColumnUN_20__Control1102755390; ColumnUN[20]) { }
            column(ColumnUN_18__Control1102755391; ColumnUN[18]) { }
            column(ColumnUN_17__Control1102755392; ColumnUN[17]) { }
            column(ColumnUN_12__Control1102755393; ColumnUN[12]) { }
            column(ColumnUN_11__Control1102755394; ColumnUN[11]) { }
            column(ColumnUN_10__Control1102755395; ColumnUN[10]) { }
            column(ColumnUN_9__Control1102755396; ColumnUN[9]) { }
            column(ColumnUN_16__Control1102755397; ColumnUN[16]) { }
            column(ColumnUN_15__Control1102755398; ColumnUN[15]) { }
            column(ColumnUN_14__Control1102755399; ColumnUN[14]) { }
            column(ColumnUN_13__Control1102755400; ColumnUN[13]) { }
            column(ColumnUN_1__Control1102755401; ColumnUN[1]) { }
            column(ColumnUN_2__Control1102755402; ColumnUN[2]) { }
            column(ColumnUN_4__Control1102755403; ColumnUN[4]) { }
            column(ColumnUN_3__Control1102755404; ColumnUN[3]) { }
            column(ColumnUN_6__Control1102755405; ColumnUN[6]) { }
            column(ColumnUN_5__Control1102755406; ColumnUN[5]) { }
            column(ColumnUN_7__Control1102755407; ColumnUN[7]) { }
            column(ColumnUN_8__Control1102755408; ColumnUN[8]) { }
            column(ColumnSD_1_; ColumnSD[1]) { }
            column(ColumnSD_2_; ColumnSD[2]) { }
            column(ColumnSD_3_; ColumnSD[3]) { }
            column(ColumnSD_4_; ColumnSD[4]) { }
            column(ColumnSD_5_; ColumnSD[5]) { }
            column(ColumnSD_6_; ColumnSD[6]) { }
            column(ColumnSD_7_; ColumnSD[7]) { }
            column(ColumnSD_8_; ColumnSD[8]) { }
            column(ColumnSD_9_; ColumnSD[9]) { }
            column(ColumnSD_10_; ColumnSD[10]) { }
            column(ColumnSD_11_; ColumnSD[11]) { }
            column(ColumnSD_12_; ColumnSD[12]) { }
            column(ColumnSD_13_; ColumnSD[13]) { }
            column(ColumnSD_14_; ColumnSD[14]) { }
            column(ColumnSD_15_; ColumnSD[15]) { }
            column(ColumnSD_16_; ColumnSD[16]) { }
            column(ColumnSD_17_; ColumnSD[17]) { }
            column(ColumnSD_18_; ColumnSD[18]) { }
            column(ColumnSD_19_; ColumnSD[19]) { }
            column(ColumnSD_20_; ColumnSD[20]) { }
            column(ColumnSD_21_; ColumnSD[21]) { }
            column(ColumnSD_22_; ColumnSD[22]) { }
            column(ColumnSD_23_; ColumnSD[23]) { }
            column(ColumnSD_24_; ColumnSD[24]) { }
            column(ColumnSD_25_; ColumnSD[25]) { }
            column(ColumnSD_26_; ColumnSD[26]) { }
            column(ColumnSD_27_; ColumnSD[27]) { }
            column(ColumnSD_28_; ColumnSD[28]) { }
            column(ColumnSD_29_; ColumnSD[29]) { }
            column(ColumnSD_30_; ColumnSD[30]) { }
            column(ColumnSD_31_; ColumnSD[31]) { }
            column(ColumnSD_32_; ColumnSD[32]) { }
            column(ColumnSD_33_; ColumnSD[33]) { }
            column(ColumnSD_34_; ColumnSD[34]) { }
            column(ColumnSD_35_; ColumnSD[35]) { }
            column(ColumnSD_36_; ColumnSD[36]) { }
            column(ColumnSD_37_; ColumnSD[37]) { }
            column(ColumnSD_38_; ColumnSD[38]) { }
            column(ColumnSD_39_; ColumnSD[39]) { }
            column(ColumnSD_40_; ColumnSD[40]) { }
            column(ColumnSD_41_; ColumnSD[41]) { }
            column(ColumnSD_42_; ColumnSD[42]) { }
            column(ColumnSD_43_; ColumnSD[43]) { }
            column(ColumnSD_44_; ColumnSD[44]) { }
            column(ColumnSD_45_; ColumnSD[45]) { }
            column(ColumnSD_46_; ColumnSD[46]) { }
            column(ColumnSD_47_; ColumnSD[47]) { }
            column(ColumnSD_48_; ColumnSD[48]) { }
            column(ColumnSD_49_; ColumnSD[49]) { }
            column(ColumnSD_50_; ColumnSD[50]) { }
            column(ColumnSD_51_; ColumnSD[51]) { }
            column(ColumnSD_52_; ColumnSD[52]) { }
            column(ColumnSD_53_; ColumnSD[53]) { }
            column(ColumnSD_54_; ColumnSD[54]) { }
            column(ColumnSD_55_; ColumnSD[55]) { }
            column(ColumnSD_56_; ColumnSD[56]) { }
            column(ColumnSD_57_; ColumnSD[57]) { }
            column(ColumnSD_58_; ColumnSD[58]) { }
            column(ColumnSD_59_; ColumnSD[59]) { }
            column(ColumnSD_60_; ColumnSD[60]) { }
            column(ColumnSD_61_; ColumnSD[61]) { }
            column(ColumnSD_62_; ColumnSD[62]) { }
            column(ColumnSD_63_; ColumnSD[63]) { }
            column(ColumnSD_64_; ColumnSD[64]) { }
            column(ColumnSD_65_; ColumnSD[65]) { }
            column(ColumnSD_66_; ColumnSD[66]) { }
            column(ColumnG_1_; ColumnG[1]) { }
            column(ColumnG_2_; ColumnG[2]) { }
            column(ColumnG_3_; ColumnG[3]) { }
            column(ColumnG_4_; ColumnG[4]) { }
            column(ColumnG_5_; ColumnG[5]) { }
            column(ColumnG_6_; ColumnG[6]) { }
            column(ColumnG_7_; ColumnG[7]) { }
            column(ColumnG_8_; ColumnG[8]) { }
            column(ColumnG_9_; ColumnG[9]) { }
            column(ColumnG_10_; ColumnG[10]) { }
            column(ColumnGV_1_; ColumnGV[1]) { }
            column(ColumnGV_2_; ColumnGV[2]) { }
            column(ColumnGV_3_; ColumnGV[3]) { }
            column(ColumnGV_4_; ColumnGV[4]) { }
            column(ColumnGV_5_; ColumnGV[5]) { }
            column(ColumnGV_6_; ColumnGV[6]) { }
            column(ColumnGV_7_; ColumnGV[7]) { }
            column(ColumnGV_8_; ColumnGV[8]) { }
            column(ColumnGV_9_; ColumnGV[9]) { }
            column(ColumnGV_10_; ColumnGV[10]) { }
            column(ColumnGV_11_; ColumnGV[11]) { }
            column(ColumnGV_12_; ColumnGV[12]) { }
            column(ColumnGV_13_; ColumnGV[13]) { }
            column(ColumnGV_14_; ColumnGV[14]) { }
            column(ColumnGV_15_; ColumnGV[15]) { }
            column(ColumnGV_16_; ColumnGV[16]) { }
            column(ColumnGV_17_; ColumnGV[17]) { }
            column(ColumnGV_18_; ColumnGV[18]) { }
            column(ColumnGV_19_; ColumnGV[19]) { }
            column(ColumnGV_20_; ColumnGV[20]) { }
            column(ColumnGV_21_; ColumnGV[21]) { }
            column(ColumnGV_22_; ColumnGV[22]) { }
            column(ColumnGV_23_; ColumnGV[23]) { }
            column(ColumnGV_24_; ColumnGV[24]) { }
            column(ColumnGV_25_; ColumnGV[25]) { }
            column(ColumnGV1_1_; ColumnGV1[1]) { }
            column(ColumnGV1_2_; ColumnGV1[2]) { }
            column(ColumnGV1_3_; ColumnGV1[3]) { }
            column(ColumnGV1_4_; ColumnGV1[4]) { }
            column(ColumnGV1_5_; ColumnGV1[5]) { }
            column(ColumnGV1_6_; ColumnGV1[6]) { }
            column(ColumnGV1_7_; ColumnGV1[7]) { }
            column(ColumnGV1_8_; ColumnGV1[8]) { }
            column(ColumnGV1_9_; ColumnGV1[9]) { }
            column(ColumnGV1_10_; ColumnGV1[10]) { }
            column(ColumnGV1_11_; ColumnGV1[11]) { }
            column(ColumnGV1_12_; ColumnGV1[12]) { }
            column(ColumnGV1_13_; ColumnGV1[13]) { }
            column(ColumnGV1_14_; ColumnGV1[14]) { }
            column(ColumnGV1_15_; ColumnGV1[15]) { }
            column(ColumnGV1_16_; ColumnGV1[16]) { }
            column(ColumnGV1_17_; ColumnGV1[17]) { }
            column(ColumnGV1_18_; ColumnGV1[18]) { }
            column(ColumnGV1_19_; ColumnGV1[19]) { }
            column(ColumnGV1_20_; ColumnGV1[20]) { }
            column(ColumnGV1_21_; ColumnGV1[21]) { }
            column(ColumnGV1_22_; ColumnGV1[22]) { }
            column(ColumnGV1_23_; ColumnGV1[23]) { }
            column(ColumnGV1_24_; ColumnGV1[24]) { }
            column(ColumnGV1_25_; ColumnGV1[25]) { }
            column(ColumnGV2_1_; ColumnGV2[1]) { }
            column(ColumnGV2_2_; ColumnGV2[2]) { }
            column(ColumnGV2_3_; ColumnGV2[3]) { }
            column(ColumnGV2_4_; ColumnGV2[4]) { }
            column(ColumnGV2_5_; ColumnGV2[5]) { }
            column(ColumnGV2_6_; ColumnGV2[6]) { }
            column(ColumnGV2_7_; ColumnGV2[7]) { }
            column(ColumnGV2_8_; ColumnGV2[8]) { }
            column(ColumnGV2_9_; ColumnGV2[9]) { }
            column(ColumnGV2_10_; ColumnGV2[10]) { }
            column(ColumnGV2_11_; ColumnGV2[11]) { }
            column(ColumnGV2_12_; ColumnGV2[12]) { }
            column(ColumnGV2_13_; ColumnGV2[13]) { }
            column(ColumnGV2_14_; ColumnGV2[14]) { }
            column(ColumnGV2_15_; ColumnGV2[15]) { }
            column(ColumnGV2_16_; ColumnGV2[16]) { }
            column(ColumnGV2_17_; ColumnGV2[17]) { }
            column(ColumnGV2_18_; ColumnGV2[18]) { }
            column(ColumnGV2_19_; ColumnGV2[19]) { }
            column(ColumnGV2_20_; ColumnGV2[20]) { }
            column(ColumnGV2_21_; ColumnGV2[21]) { }
            column(ColumnGV2_22_; ColumnGV2[22]) { }
            column(ColumnGV2_23_; ColumnGV2[23]) { }
            column(ColumnGV2_24_; ColumnGV2[24]) { }
            column(ColumnGV2_25_; ColumnGV2[25]) { }
            column(ColumnGV3_1_; ColumnGV3[1]) { }
            column(ColumnGV3_2_; ColumnGV3[2]) { }
            column(ColumnGV3_3_; ColumnGV3[3]) { }
            column(ColumnGV3_4_; ColumnGV3[4]) { }
            column(ColumnGV3_5_; ColumnGV3[5]) { }
            column(ColumnGV3_6_; ColumnGV3[6]) { }
            column(ColumnGV3_7_; ColumnGV3[7]) { }
            column(ColumnGV3_8_; ColumnGV3[8]) { }
            column(ColumnGV3_9_; ColumnGV3[9]) { }
            column(ColumnGV3_10_; ColumnGV3[10]) { }
            column(ColumnGV3_11_; ColumnGV3[11]) { }
            column(ColumnGV3_12_; ColumnGV3[12]) { }
            column(ColumnGV3_13_; ColumnGV3[13]) { }
            column(ColumnGV3_14_; ColumnGV3[14]) { }
            column(ColumnGV3_15_; ColumnGV3[15]) { }
            column(ColumnGV3_16_; ColumnGV3[16]) { }
            column(ColumnGV3_17_; ColumnGV3[17]) { }
            column(ColumnGV3_18_; ColumnGV3[18]) { }
            column(ColumnGV3_19_; ColumnGV3[19]) { }
            column(ColumnGV3_20_; ColumnGV3[20]) { }
            column(ColumnGV3_21_; ColumnGV3[21]) { }
            column(ColumnGV3_22_; ColumnGV3[22]) { }
            column(ColumnGV3_23_; ColumnGV3[23]) { }
            column(ColumnGV3_24_; ColumnGV3[24]) { }
            column(ColumnGV3_25_; ColumnGV3[25]) { }
            column(ColumnGV4_1_; ColumnGV4[1]) { }
            column(ColumnGV4_2_; ColumnGV4[2]) { }
            column(ColumnGV4_3_; ColumnGV4[3]) { }
            column(ColumnGV4_4_; ColumnGV4[4]) { }
            column(ColumnGV4_5_; ColumnGV4[5]) { }
            column(ColumnGV4_6_; ColumnGV4[6]) { }
            column(ColumnGV4_7_; ColumnGV4[7]) { }
            column(ColumnGV4_8_; ColumnGV4[8]) { }
            column(ColumnGV4_9_; ColumnGV4[9]) { }
            column(ColumnGV4_10_; ColumnGV4[10]) { }
            column(ColumnGV4_11_; ColumnGV4[11]) { }
            column(ColumnGV4_12_; ColumnGV4[12]) { }
            column(ColumnGV4_13_; ColumnGV4[13]) { }
            column(ColumnGV4_14_; ColumnGV4[14]) { }
            column(ColumnGV4_15_; ColumnGV4[15]) { }
            column(ColumnGV4_16_; ColumnGV4[16]) { }
            column(ColumnGV4_17_; ColumnGV4[17]) { }
            column(ColumnGV4_18_; ColumnGV4[18]) { }
            column(ColumnGV4_19_; ColumnGV4[19]) { }
            column(ColumnGV4_20_; ColumnGV4[20]) { }
            column(ColumnGV4_21_; ColumnGV4[21]) { }
            column(ColumnGV4_22_; ColumnGV4[22]) { }
            column(ColumnGV4_23_; ColumnGV4[23]) { }
            column(ColumnGV4_24_; ColumnGV4[24]) { }
            column(ColumnGV4_25_; ColumnGV4[25]) { }
            column(ColumnGV5_1_; ColumnGV5[1]) { }
            column(ColumnGV5_2_; ColumnGV5[2]) { }
            column(ColumnGV5_3_; ColumnGV5[3]) { }
            column(ColumnGV5_4_; ColumnGV5[4]) { }
            column(ColumnGV5_5_; ColumnGV5[5]) { }
            column(ColumnGV5_6_; ColumnGV5[6]) { }
            column(ColumnGV5_7_; ColumnGV5[7]) { }
            column(ColumnGV5_8_; ColumnGV5[8]) { }
            column(ColumnGV5_9_; ColumnGV5[9]) { }
            column(ColumnGV5_10_; ColumnGV5[10]) { }
            column(ColumnGV5_11_; ColumnGV5[11]) { }
            column(ColumnGV5_12_; ColumnGV5[12]) { }
            column(ColumnGV5_13_; ColumnGV5[13]) { }
            column(ColumnGV5_14_; ColumnGV5[14]) { }
            column(ColumnGV5_15_; ColumnGV5[15]) { }
            column(ColumnGV5_16_; ColumnGV5[16]) { }
            column(ColumnGV5_17_; ColumnGV5[17]) { }
            column(ColumnGV5_18_; ColumnGV5[18]) { }
            column(ColumnGV5_19_; ColumnGV5[19]) { }
            column(ColumnGV5_20_; ColumnGV5[20]) { }
            column(ColumnGV5_21_; ColumnGV5[21]) { }
            column(ColumnGV5_22_; ColumnGV5[22]) { }
            column(ColumnGV5_23_; ColumnGV5[23]) { }
            column(ColumnGV5_24_; ColumnGV5[24]) { }
            column(ColumnGV5_25_; ColumnGV5[25]) { }
            column(ColumnGV6_1_; ColumnGV6[1]) { }
            column(ColumnGV6_2_; ColumnGV6[2]) { }
            column(ColumnGV6_3_; ColumnGV6[3]) { }
            column(ColumnGV6_4_; ColumnGV6[4]) { }
            column(ColumnGV6_5_; ColumnGV6[5]) { }
            column(ColumnGV6_6_; ColumnGV6[6]) { }
            column(ColumnGV6_7_; ColumnGV6[7]) { }
            column(ColumnGV6_8_; ColumnGV6[8]) { }
            column(ColumnGV6_9_; ColumnGV6[9]) { }
            column(ColumnGV6_10_; ColumnGV6[10]) { }
            column(ColumnGV6_11_; ColumnGV6[11]) { }
            column(ColumnGV6_12_; ColumnGV6[12]) { }
            column(ColumnGV6_13_; ColumnGV6[13]) { }
            column(ColumnGV6_14_; ColumnGV6[14]) { }
            column(ColumnGV6_15_; ColumnGV6[15]) { }
            column(ColumnGV6_16_; ColumnGV6[16]) { }
            column(ColumnGV6_17_; ColumnGV6[17]) { }
            column(ColumnGV6_18_; ColumnGV6[18]) { }
            column(ColumnGV6_19_; ColumnGV6[19]) { }
            column(ColumnGV6_20_; ColumnGV6[20]) { }
            column(ColumnGV6_21_; ColumnGV6[21]) { }
            column(ColumnGV6_22_; ColumnGV6[22]) { }
            column(ColumnGV6_23_; ColumnGV6[23]) { }
            column(ColumnGV6_24_; ColumnGV6[24]) { }
            column(ColumnGV6_25_; ColumnGV6[25]) { }
            column(ColumnGV7_1_; ColumnGV7[1]) { }
            column(ColumnGV7_2_; ColumnGV7[2]) { }
            column(ColumnGV7_3_; ColumnGV7[3]) { }
            column(ColumnGV7_4_; ColumnGV7[4]) { }
            column(ColumnGV7_5_; ColumnGV7[5]) { }
            column(ColumnGV7_6_; ColumnGV7[6]) { }
            column(ColumnGV7_7_; ColumnGV7[7]) { }
            column(ColumnGV7_8_; ColumnGV7[8]) { }
            column(ColumnGV7_9_; ColumnGV7[9]) { }
            column(ColumnGV7_10_; ColumnGV7[10]) { }
            column(ColumnGV7_11_; ColumnGV7[11]) { }
            column(ColumnGV7_12_; ColumnGV7[12]) { }
            column(ColumnGV7_13_; ColumnGV7[13]) { }
            column(ColumnGV7_14_; ColumnGV7[14]) { }
            column(ColumnGV7_15_; ColumnGV7[15]) { }
            column(ColumnGV7_16_; ColumnGV7[16]) { }
            column(ColumnGV7_17_; ColumnGV7[17]) { }
            column(ColumnGV7_18_; ColumnGV7[18]) { }
            column(ColumnGV7_19_; ColumnGV7[19]) { }
            column(ColumnGV7_20_; ColumnGV7[20]) { }
            column(ColumnGV7_21_; ColumnGV7[21]) { }
            column(ColumnGV7_22_; ColumnGV7[22]) { }
            column(ColumnGV7_23_; ColumnGV7[23]) { }
            column(ColumnGV7_24_; ColumnGV7[24]) { }
            column(ColumnGV7_25_; ColumnGV7[25]) { }
            column(GenSetup__Cons__Marksheet_Key1__Control1102755442; GenSetup."Cons. Marksheet Key1") { }
            column(GenSetup__Cons__Marksheet_Key2__Control1102755443; GenSetup."Cons. Marksheet Key2") { }
            column(SMM_2_; SMM[2]) { }
            column(SMM_4_; SMM[4]) { }
            column(SMM_3_; SMM[3]) { }
            column(SMM_6_; SMM[6]) { }
            column(SMM_5_; SMM[5]) { }
            column(SMM_8_; SMM[8]) { }
            column(SMM_7_; SMM[7]) { }
            column(SMM_10_; SMM[10]) { }
            column(SMM_9_; SMM[9]) { }
            column(Dean___FDesc_Control1102755003; 'Dean ' + FDesc) { }
            column(School_Caption; School_CaptionLbl) { }
            column(Department_Caption; Department_CaptionLbl) { }
            column(Programme_of_Study_Caption; Programme_of_Study_CaptionLbl) { }
            column(Stage_Caption; Stage_CaptionLbl) { }
            column(Academic_Year_Caption; Academic_Year_CaptionLbl) { }
            column(Consolidated_MarksheetCaption; Consolidated_MarksheetCaptionLbl) { }
            column(Semester_Caption; Semester_CaptionLbl) { }
            column(Registration_No_Caption; Registration_No_CaptionLbl) { }
            column(NamesCaption; NamesCaptionLbl) { }
            column(UNITS__Caption; UNITS__CaptionLbl) { }
            column(EmptyStringCaption; EmptyStringCaptionLbl) { }
            column(Units_Key_Caption; Units_Key_CaptionLbl) { }
            column(Approved_by_the_Departmental_Board_of_ExaminersCaption; Approved_by_the_Departmental_Board_of_ExaminersCaptionLbl) { }
            column(Approved_by_the_School_Board_of_ExaminersCaption; Approved_by_the_School_Board_of_ExaminersCaptionLbl) { }
            column(Signed_______________________________________Caption; Signed_______________________________________CaptionLbl) { }
            column(Signed_______________________________________Caption_Control1102755449; Signed_______________________________________Caption_Control1102755449Lbl) { }
            column(Signed_______________________________________Caption_Control1102755450; Signed_______________________________________Caption_Control1102755450Lbl) { }
            column(Approved_by_DeKUT_SenateCaption; Approved_by_DeKUT_SenateCaptionLbl) { }
            column(Chairperson_of_DepartmentCaption; Chairperson_of_DepartmentCaptionLbl) { }
            column(AG_VC_DeKUTCaption; AG_VC_DeKUTCaptionLbl) { }
            column(Guide_on_Remarks_Caption; Guide_on_Remarks_CaptionLbl) { }
            column(Guide_on_remarks_Caption_Control1102760087; Guide_on_remarks_Caption_Control1102760087Lbl) { }
            column(Total_Reg_Caption; Total_Reg_CaptionLbl) { }
            column(Mean_ScoreCaption; Mean_ScoreCaptionLbl) { }
            column(Maximum_ScoreCaption; Maximum_ScoreCaptionLbl) { }
            column(Minimum_ScoreCaption; Minimum_ScoreCaptionLbl) { }
            column(Units_Key_Caption_Control1102755384; Units_Key_Caption_Control1102755384Lbl) { }
            column(Approved_by_the_Departmental_Board_of_ExaminersCaption_Control1000000009; Approved_by_the_Departmental_Board_of_ExaminersCaption_Control1000000009Lbl) { }
            column(Approved_by_the_School_Board_of_ExaminersCaption_Control1000000010; Approved_by_the_School_Board_of_ExaminersCaption_Control1000000010Lbl) { }
            column(Signed_______________________________________Caption_Control1000000011; Signed_______________________________________Caption_Control1000000011Lbl) { }
            column(Signed_______________________________________Caption_Control1000000012; Signed_______________________________________Caption_Control1000000012Lbl) { }
            column(Signed_______________________________________Caption_Control1000000013; Signed_______________________________________Caption_Control1000000013Lbl) { }
            column(Approved_by_DeKUT_SenateCaption_Control1000000014; Approved_by_DeKUT_SenateCaption_Control1000000014Lbl) { }
            column(Chairperson_of_DepartmentCaption_Control1000000015; Chairperson_of_DepartmentCaption_Control1000000015Lbl) { }
            column(Chairperson_SenateCaption; Chairperson_SenateCaptionLbl) { }
            column(Standard_DeviationCaption; Standard_DeviationCaptionLbl) { }
            column(Course_Registration_Reg__Transacton_ID; "Reg. Transacton ID") { }
            column(Course_Registration_Student_No_; "Student No.") { }
            column(Course_Registration_Programme; Programme) { }
            column(Course_Registration_Semester; Semester) { }
            column(Course_Registration_Register_for; "Register for") { }
            column(Course_Registration_Stage; Stage) { }
            column(Course_Registration_Unit; Unit) { }
            column(Course_Registration_Student_Type; "Student Type") { }
            column(Course_Registration_Entry_No_; "Entry No.") { }

            trigger OnAfterGetRecord()
            begin

                //ExamProc.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".GETFILTER("Stage Filter"),"Course Registration".Semester);
                "Course Registration".CalcFields("School Filter");
                "Course Registration".CalcFields("Programme Category");
                //ERROR((COPYSTR("Course Registration"."Student No.",STRLEN("Course Registration"."Student No.")-1,2)));
                //IF (COPYSTR("Course Registration"."Student No.",STRLEN("Course Registration"."Student No.")-1,2)<'16') OR ("Course Registration"."School Filter"='SBE')
                //  OR ("Course Registration"."Programme Category"<>"Course Registration"."Programme Category"::Undergraduate) THEN BEGIN

                TReg := "Course Registration".Count;
                SCount := SCount + 1;
                i := 0;
                TScore := 0;
                CFTotal := 0;
                RUnits := 0;
                MissingM := false;
                MCourse := false;
                CCat := '';


                for i := 1 to K_Max do begin
                    ColumnV[i] := '';
                    AvScoreCount[i] := 0;
                    //AvScore[i]:=0;
                end;
                i := 0;



                if Dept = '' then begin
                    if Prog.Get("Course Registration".Programme) then begin
                        PName := Prog.Description;
                        FDesc := Prog."School Code";

                        i := 1;
                        Gradings.Reset;
                        Gradings.SetRange(Gradings.Category, Prog."Exam Category");
                        if Gradings.Find('-') then begin
                            repeat
                                GLabel[i] := Gradings.Range;
                                GLabel2[i] := Gradings.Grade;
                                i := i + 1;
                            until Gradings.Next = 0;
                        end;

                        FacultyR.Reset;
                        FacultyR.SetRange(FacultyR.Code, Prog."School Code");
                        if FacultyR.Find('-') then
                            FDesc := FacultyR.Name;

                        i := 0;
                        DValue.Reset;
                        DValue.SetRange(DValue.Code, ProgrammeRec."Department Code");
                        DValue.SetRange(DValue."Dimension Code", 'DEPARTMENT');
                        if DValue.Find('-') then
                            Dept := DValue.Name;

                    end;
                end;

                SDesc := "Course Registration".GetFilter("Course Registration"."Semester Filter");

                "Course Registration".CalcFields("Course Registration"."Units Taken", "Course Registration"."Units Passed",
                                                 "Course Registration"."Units Failed");


                FailedUnits := '';
                for K := 1 to K_Max do begin
                    CCat := '';
                    uColumnV[K] := '';
                    ColumnV[K] := '';
                    ColumnH[K] := UnitShow[K];
                    ColumnH2[K] := UnitShow[K];
                    uColumnV[K] := Format(UnitShow2[K]);
                    StudUnits.Reset;
                    StudUnits.SetRange(StudUnits."Student No.", "Course Registration"."Student No.");
                    StudUnits.SetRange(StudUnits.Unit, UnitShow[K]);
                    if StudUnits.Find('-') then begin
                        StudUnits.CalcFields(StudUnits."Exam Marks");
                        StudUnits.CalcFields(StudUnits."CAT Total Marks");
                        StudUnits.CalcFields(StudUnits."Total Score");
                        StudUnits.CalcFields(StudUnits."Project Unit");
                        StudUnits.CalcFields(StudUnits."Is Attachment Unit");
                        StudUnits.CalcFields(StudUnits."CF Lk");
                        //if (StudUnits."Total Score" <> StudUnits."Final Score") or (StudUnits."No. Of Units" <> StudUnits."CF Lk") then
                        ExamProc.UpdateStudentUnits(StudUnits."Student No.", StudUnits.Programme, StudUnits.Semester, StudUnits.Stage, StudUnits.Unit);

                        CCat := StudUnits."Grade Prefix";
                        if (StudUnits."Total Score") = 0 then CCat := 'X';
                        if StudUnits."Result Status" <> 'PASS' then FailedUnits := FailedUnits + StudUnits.Unit + ',';
                        if (StudUnits."Total Score") <> 0 then begin
                            if StudUnits."Exam Marks" = 0 then begin
                                if Sem.Get("Course Registration".Semester) then
                                    if (Sem."BackLog Marks" = false) and (StudUnits."Is Attachment Unit" = false) then
                                        CCat := '*';
                            end;
                            if StudUnits."CAT Total Marks" = 0 then begin
                                if Sem.Get("Course Registration".Semester) then
                                    if (Sem."BackLog Marks" = false) and (StudUnits."Is Attachment Unit" = false) then
                                        CCat := '**';
                            end;

                            if StudUnits.Moderated = true then CCat := '^';

                        end;



                        //CFTotal:=CFTotal+UnitsR."No. Units";
                        AvScore[K] := AvScore[K] + StudUnits."Total Score";
                        sColumnV[K] := CopyStr("Course Registration".Stage, 3, 2);
                        if StudUnits."Total Score" = 0 then
                            if CCat = '--' then
                                ColumnV[K] := ''

                            else begin
                                MissingM := true;
                                MCourse := true;
                                ColumnV[K] := '';
                            end
                        else begin
                            ColumnV[K] := Format(ROUND(StudUnits."Total Score", 1, '=')) + CCat;
                            //ColumnV[i]:=FORMAT(UnitsR."Total Score") + CCat;
                            TScore := TScore + StudUnits."Total Score";

                            CCat := '';
                        end;
                    end else begin
                        ColumnV[K] := '';
                    end;
                end;

                i := 0;


                if Cust.Get("Course Registration"."Student No.") then

                    //Generate Summary
                    UTaken := 0;
                UPassed := 0;
                UFailed := 0;
                CAve := 0;

                if DSummary = false then begin

                    //Jump one column

                    i := 31;
                    /*
                    ColumnH[i]:='';
                    ColumnV[i]:='';
                    */

                    "Course Registration".CalcFields("Course Registration"."Cum Average");
                    "Course Registration".CalcFields("Course Registration"."Cum Units Done");
                    "Course Registration".CalcFields("Course Registration"."Cum Units Failed");
                    "Course Registration".CalcFields("Course Registration"."Cum Units Passed");
                    "Course Registration".CalcFields("Course Registration"."Cum Units Passed Cores");
                    "Course Registration".CalcFields("Course Registration"."CF Count");
                    "Course Registration".CalcFields("Course Registration"."CF Total Score");

                    i := i + 1;
                    ColumnH[i] := 'Total Units';
                    //ColumnV[i]:=FORMAT(UTaken);
                    ColumnV[i] := Format("Course Registration"."CF Count");
                    //IF ("Course Registration"."CF Count">Prog."Min Pass Units") AND (Prog."Min Pass Units">0) THEN
                    //ColumnV[i]:=FORMAT(Prog."Min Pass Units");

                    //TReg:=TReg+1;
                    AvScoreCount[i] := AvScoreCount[i] + "Course Registration"."Cum Units Done";


                    i := i + 1;
                    ColumnH[i] := 'No. of Courses';
                    ColumnV[i] := Format("Course Registration"."Cum Units Done");
                    //IF ("Course Registration"."Cum Units Done">MinUnits) AND (MinUnits>0) THEN
                    //ColumnV[i]:=FORMAT(MinUnits);

                    i := i + 1;
                    ColumnH[i] := 'Weighted Total';
                    "Course Registration".CalcFields("Course Registration"."CF Total Score");
                    "Course Registration".CalcFields("Course Registration"."CF Total Score");
                    ColumnV[i] := Format("Course Registration"."CF Total Score");


                    //AvScore[i]:=AvScore[i]+"Course Registration"."Cum Units Passed";
                    /*

                    i:=i+1;
                    ColumnH[i]:='Weighted Total (WT)';
                    "Course Registration".CALCFIELDS("Course Registration"."Cum Units Failed") ;
                    ColumnV[i]:=FORMAT("Course Registration"."Cum Units Failed");
                    //AvScore[i]:=AvScore[i]+"Course Registration"."Cum Units Failed";

                    i:=i+1;
                    "Course Registration".CALCFIELDS("Course Registration"."Cum Units Special") ;
                    ColumnH[i]:='Units Special';
                    ColumnV[i]:=FORMAT("Course Registration"."Cum Units Special");


                    i:=i+1;
                    ColumnH[i]:='CF% Failed';
                    IF ("Course Registration"."Cum Units Passed"<>0) AND ("Course Registration"."Cum Units Done"<>0) THEN BEGIN
                    ColumnV[i]:=FORMAT(ROUND((("Course Registration"."Cum Units Done"-("Course Registration"."Cum Units Passed"+"Course Registration"."Cum Units Special"))/
                    "Course Registration"."Cum Units Done")*100,0.5,'='));

                    IF (("Course Registration"."Cum Units Done"-"Course Registration"."Cum Units Passed")/"Course Registration"."Cum Units Done")*100>25 THEN
                    "Course Registration"."Exam Status":='REPEAT';
                    IF (("Course Registration"."Cum Units Done"-"Course Registration"."Cum Units Passed")/"Course Registration"."Cum Units Done")*100>51 THEN
                    "Course Registration"."Exam Status":='Discontinue';
                    //"Course Registration".MODIFY;

                    END;
                    */
                    i := i + 1;
                    //calculate yearly average
                    ColumnH[i] := 'Weighted Average';
                    "Course Registration".CalcFields("CF Count Cores");
                    "Course Registration".CalcFields("CF Total Score Cores");
                    if "Course Registration"."CF Count Cores" >= MinUnits then
                        if ("Course Registration"."CF Count Cores" > 0) and ("Course Registration"."CF Total Score Cores" > 0) then
                            ColumnV[i] := Format(ROUND("Course Registration"."CF Total Score Cores" / "Course Registration"."CF Count Cores", 0.01, '>'));
                    if Prog."School Code" <> 'SASS' then begin
                        if ("Course Registration"."CF Total Score" > 0) and ("Course Registration"."CF Count" > 0) then begin
                            ColumnV[i] := Format(ROUND("Course Registration"."CF Total Score" / "Course Registration"."CF Count", 0.01, '>'));
                            "Course Registration"."Cumm Score" := ROUND("Course Registration"."CF Total Score" / "Course Registration"."CF Count", 0.01, '>');
                        end;

                        if StrLen(ColumnV[i]) = 2 then
                            ColumnV[i] := ColumnV[i] + '.00';
                        if StrLen(ColumnV[i]) = 4 then
                            ColumnV[i] := ColumnV[i] + '0';

                    end;
                    //"Course Registration".MODIFY;
                    /*
                    i:=i+1;

                    //calculate yearly average GRADE
                    DefUnit:='DEF';
                    ColumnH[i]:='Grade';
                    IF ("Course Registration"."CF Total Score" > 0) AND ("Course Registration"."CF Count">0) THEN
                    ColumnV[i]:=GetGrade(("Course Registration"."CF Total Score"/"Course Registration"."CF Count"),DefUnit);
                    */
                    i := i + 1;

                    ColumnH[i] := 'Rmk';

                    if ResultStatus.Get("Course Registration"."Exam Status") then
                        ColumnV[i] := ResultStatus.Prefix;

                    //IF "Course Registration"."Exam Status"='PASS' THEN
                    if ("Course Registration"."Cum Units Failed" <> 0) then begin
                        ColumnV[i] := 'RESIT';
                        if StrLen("Course Registration".GetFilter("Semester Filter")) < 15 then
                            ColumnV[i] := 'FAIL';
                    end;


                    if ("Course Registration"."Cum Units Done" <> 0) and ("Course Registration"."Cum Units Passed" <> 0)
                    and ("Course Registration"."Cum Units Failed" = 0) then
                        ColumnV[i] := 'PASS';

                    if ColumnV[i] = 'PASS' then begin
                        if "Course Registration"."CF Count" < MinUnits then
                            ColumnV[i] := 'INCOMPLETE';
                    end;

                    if ColumnV[i] = 'PASS' then begin
                        if CheckPassAllYears("Course Registration"."Student No.", "Course Registration".Programme, CopyStr("Course Registration".Stage, 2, 1)) = false then
                            ColumnV[i] := 'INCOMPLET';
                    end;

                    FailedUnits := '';

                    if ColumnV[i] = 'RESIT' then begin
                        i := i + 1;
                        ColumnV[i] := FailedUnits;
                    end;
                    if StrLen("Course Registration".GetFilter("Semester Filter")) > 15 then begin
                        if FailPerc > 25 then ColumnV[i] := 'RETAKE';
                        if FailPerc > 50 then ColumnV[i] := 'DISCOUNTINUED';
                    end;
                    // if StrLen("Course Registration".GetFilter("Semester Filter")) < 15 then begin
                    if ("Course Registration"."Cum Units Deffered CAT" > 0) or ("Course Registration"."Cum Units Deffered EXAM" > 0) then begin
                        if ("Course Registration"."Cum Units Failed" > 0) and (("Course Registration"."Cum Units Deffered CAT" > 0) or ("Course Registration"."Cum Units Deffered EXAM" > 0)) then
                            ColumnV[i] := 'FAIL DEFERRED'
                        else
                            ColumnV[i] := 'DEFERRED';
                    end;
                    /*
                    IF ResultStatus.GET("Course Registration"."Exam Status") THEN
                    IF ResultStatus."Manual Status Processing"=FALSE THEN BEGIN

                    IF ("Course Registration"."Cum Units Done" <> 0) AND ("Course Registration"."Cum Units Passed"<>0)
                    AND ("Course Registration"."Cum Units Failed"=0) THEN
                    IF "Course Registration"."Cum Units Done"="Course Registration"."Cum Units Passed" THEN BEGIN

                    TPass:=TPass+1;
                    IF ResultStatus.GET('PASS') THEN BEGIN
                    ColumnV[i]:=ResultStatus.Prefix;
                    "Course Registration"."Exam Status":='PASS';

                    //"Course Registration".MODIFY;
                    END;
                    END;


                    IF "Course Registration"."Cum Units Failed" > 0 THEN BEGIN
                    IF ResultStatus.GET("Course Registration"."Exam Status") THEN
                    IF ResultStatus."Manual Status Processing"=FALSE THEN BEGIN

                    IF ResultStatus.GET('FAIL') THEN BEGIN
                    ColumnV[i]:=ResultStatus.Prefix;
                    "Course Registration"."Exam Status":='FAIL';
                    //"Course Registration".MODIFY;
                    END;
                    IF MCourse = FALSE THEN
                    TFail:=TFail+1;
                    END;
                    END;

                    IF MCourse = TRUE THEN BEGIN
                    IF ResultStatus.GET("Course Registration"."Exam Status") THEN
                    IF ResultStatus."Manual Status Processing"=FALSE THEN BEGIN
                    IF ResultStatus.GET('INCOMPLETE') THEN
                    ColumnV[i]:=ResultStatus.Prefix;

                    "Course Registration"."Exam Status":='INCOMPLETE';
                    //"Course Registration".MODIFY;
                    END;
                    TMiss:=TMiss+1;
                    END;

                    IF "Course Registration"."Cum Units Failed" >7 THEN BEGIN
                    IF ResultStatus.GET("Course Registration"."Exam Status") THEN
                    IF ResultStatus."Manual Status Processing"=FALSE THEN BEGIN

                    IF ResultStatus.GET('DISCONTINUED') THEN
                    ColumnV[i]:=ResultStatus.Prefix;
                    "Course Registration"."Exam Status":='DISCONTINUED';
                    //"Course Registration".MODIFY;

                    TDiscount:=TDiscount+1;
                    END;
                    END;
                    IF ("Course Registration"."Cum Units Failed" <8) AND ("Course Registration"."Cum Units Failed" >5) THEN BEGIN
                    IF ResultStatus.GET("Course Registration"."Exam Status") THEN
                    IF ResultStatus."Manual Status Processing"=FALSE THEN BEGIN

                    IF ResultStatus.GET('REPEAT') THEN
                    ColumnV[i]:=ResultStatus.Prefix;
                    "Course Registration"."Exam Status":='REPEAT';
                    //"Course Registration".MODIFY;

                    TRepeat:=TRepeat+1;
                    END;
                    END;
                     {
                    IF Prog.GET("Course Registration".Programme) THEN BEGIN
                    IF "Course Registration"."Units Taken" < Prog."Min No. of Courses" THEN
                    ColumnV[i]:='?';
                    END;
                    }
                    IF Cust.Status=Cust.Status::"Dropped Out" THEN
                    ColumnV[i]:='Z';

                    {
                    IF (UTaken < 1) OR ((UPassed<14) AND (ColumnV[i]='P')) THEN   //BKK
                    ColumnV[i]:='?';


                    i:=i+1;
                    ColumnH[i]:='Brd Rmk';
                    ColumnV[i]:='';
                     }
                    END;
                     */

                end;
                //Generate Summary
                if CalStatistics = true then begin
                    //Summary
                    i := 0;
                    Prog.Get("Course Registration".Programme);
                    Prog.TestField("Exam Category");
                    Gradings2.Reset;
                    Gradings2.SetRange(Gradings2.Category, Prog."Exam Category");
                    Gradings2.Ascending := false;
                    if Gradings2.Find('-') then begin
                        repeat
                            i := i + 1;
                            ColumnG[i] := Gradings2.Grade;
                        until Gradings2.Next = 0;
                    end;

                    i := 1;
                    ResultStatus.Reset;
                    ResultStatus.SetCurrentkey(ResultStatus."Order No");
                    ResultStatus.SetFilter(ResultStatus."Programme Filter", "Course Registration".GetFilter("Course Registration"."Programme Filter"));
                    ResultStatus.SetFilter(ResultStatus."Stage Filter", "Course Registration".GetFilter("Course Registration"."Stage Filter"));
                    ResultStatus.SetFilter(ResultStatus.Semester, "Course Registration".GetFilter("Course Registration".Semester));
                    ResultStatus.SetFilter(ResultStatus."Session Filter", "Course Registration".GetFilter("Course Registration".Session));
                    if ResultStatus.Find('-') then begin
                        repeat
                            if ResultStatus."Order No" <> 0 then begin
                                ResultStatus.CalcFields(ResultStatus."Students Count");
                                SMM[i] := ResultStatus.Code + '=' + Format(ResultStatus."Students Count");
                                //TReg:=TReg+ResultStatus."Students Count";
                                i := i + 1;
                            end;
                        until ResultStatus.Next = 0;
                    end;

                    j := 2;
                    for i := 1 to 80 do begin
                        if j < 80 then
                            j := j + 1;
                        StudUnits.Reset;
                        StudUnits.SetRange(StudUnits.Unit, ColumnH[i]);
                        StudUnits.SetFilter(StudUnits.Programme, "Course Registration".GetFilter("Programme Filter"));
                        StudUnits.SetFilter(StudUnits.Stage, "Course Registration".GetFilter("Course Registration"."Stage Filter"));
                        StudUnits.SetFilter(StudUnits.Semester, "Course Registration".GetFilter("Course Registration"."Semester Filter"));
                        StudUnits.SetFilter(StudUnits."Final Score", '<>%1', 0);
                        if StudUnits.Find('-') then begin
                            repeat
                                AvScore[i] := AvScore[i] + StudUnits."Final Score";
                            until StudUnits.Next = 0;
                        end;
                        // ColumnVA[i]:=FORMAT((TReg));
                        if (AvScore[i] <> 0) and (TReg <> 0) then begin
                            ColumnVA[i] := Format(ROUND((AvScore[i] / TReg), 0.5, '>'));
                            STD[i] := STD[i] + ROUND((AvScore[i] - (AvScore[i] / TReg)), 0.5, '>');

                        end;
                        if STD[i] > 0 then begin
                            STD[i] := Power((STD[i] / "Course Registration".Count), 0.5);
                            ColumnSD[i] := Format(ROUND(STD[i], 0.01, '>'));
                        end;
                        StudUnits.Reset;
                        StudUnits.SetCurrentkey("Final Score");
                        StudUnits.SetRange(StudUnits.Unit, ColumnH[i]);
                        StudUnits.SetFilter(StudUnits.Programme, "Course Registration".GetFilter("Programme Filter"));
                        StudUnits.SetFilter(StudUnits.Stage, "Course Registration".GetFilter("Course Registration"."Stage Filter"));
                        StudUnits.SetFilter(StudUnits.Semester, "Course Registration".GetFilter("Course Registration"."Semester Filter"));
                        StudUnits.SetFilter(StudUnits."Final Score", '<>%1', 0);
                        if StudUnits.Find('+') then
                            ColumnVM[i] := Format(ROUND(StudUnits."Final Score", 0.01, '>'));

                        StudUnits.Reset;
                        StudUnits.SetCurrentkey("Final Score");
                        StudUnits.SetRange(StudUnits.Unit, ColumnH[i]);
                        StudUnits.SetFilter(StudUnits.Programme, "Course Registration".GetFilter("Programme Filter"));
                        StudUnits.SetFilter(StudUnits.Stage, "Course Registration".GetFilter("Course Registration"."Stage Filter"));
                        StudUnits.SetFilter(StudUnits.Semester, "Course Registration".GetFilter("Course Registration"."Semester Filter"));
                        StudUnits.SetFilter(StudUnits."Final Score", '<>%1', 0);
                        if StudUnits.Find('-') then
                            ColumnVX[i] := Format(ROUND(StudUnits."Final Score", 0.01, '>'));
                        //   ColumnVX[i]:='000';
                        // END;
                    end;
                end;

                for K := 1 to 50 do begin
                    UnitsRR.Reset;
                    UnitsRR.SetRange(Code, UnitShow[K]);
                    UnitsRR.SetRange("Programme Code", "Course Registration".GetFilter("Course Registration"."Programme Filter"));
                    if UnitsRR.Find('-') then begin
                        ColumnUN[K] := UnitShow[K] + ' - ' + UnitsRR.Desription;
                    end;
                end;

                //END ELSE BEGIN
                //CurrReport.SKIP;
                //END;

            end;

            trigger OnPreDataItem()
            begin

                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
                FDesc := '';
                //Dept:='';
                SDesc := '';
                Comb := '';

                SCount := 0;
                GenSetup.Get;

                i := 0;
                if ("Course Registration".GetFilter("Academic Year") <> '') and ("Course Registration".GetFilter("Course Registration"."Semester Filter") = '') then begin
                    Sem.Reset;
                    Sem.SetFilter(Sem."Academic Year", "Course Registration".GetFilter("Academic Year"));
                    if Sem.Find('-') then begin
                        repeat
                            SemFilter := SemFilter + Sem.Code + '..';
                            SemFilter2 := Sem.Code;
                        until Sem.Next = 0;
                    end;
                end;


                if SemFilter <> '' then
                    SemFilter := CopyStr(SemFilter, 1, StrLen(SemFilter) - 2);

                if ("Course Registration".GetFilter("Study Year Filter") <> '') and ("Course Registration".GetFilter("Course Registration"."Stage Filter") = '') then begin
                    if StudyYear.Get("Course Registration".GetFilter("Study Year Filter")) then
                        StageFilter := StudyYear."Stage Filter";
                    StageFilter2 := CopyStr(StudyYear."Stage Filter", 1, 4);
                end;

                if SemFilter = '' then begin
                    SemFilter := "Course Registration".GetFilter("Course Registration"."Semester Filter");
                    SemFilter2 := "Course Registration".GetRangeMin("Course Registration"."Semester Filter");
                end;
                if StageFilter = '' then begin
                    StageFilter := "Course Registration".GetFilter("Course Registration"."Stage Filter");
                    StageFilter2 := "Course Registration".GetRangeMin("Course Registration"."Stage Filter");
                end;
                Sem.Reset;
                Sem.SetFilter(Sem.Code, SemFilter2);
                if Sem.Find('-') then
                    SemYear := Sem."Academic Year";

                YearDesc := CopyStr(StageFilter, 2, 1);
                if YearDesc = '1' then
                    YearDesc := 'FIRST';
                if YearDesc = '2' then
                    YearDesc := 'SECOND';
                if YearDesc = '3' then
                    YearDesc := 'THIRD';
                if YearDesc = '4' then
                    YearDesc := 'FOURTH';

                //ERROR(StageFilter);
                //Intake:=CReg."Intake Code";
                "Course Registration".SetFilter(Programme, GetFilter("Programme Filter"));
                "Course Registration".SetFilter("Course Registration".Options, GetFilter("Options Filter"));

                "Course Registration".SetFilter("Course Registration".Semester, SemFilter2);
                "Course Registration".SetFilter("Course Registration"."Semester Filter", SemFilter);
                "Course Registration".SetFilter("Course Registration"."Stage Filter", StageFilter);
                "Course Registration".SetFilter("Course Registration".Stage, StageFilter2);

                Stages.Reset;
                Stages.SetFilter(Stages.Code, StageFilter2);
                Stages.SetFilter(Stages."Programme Code", GetFilter("Programme Filter"));
                if Stages.Find('-') then begin
                    MinUnits := Stages."Minimum Pass All";
                    MinCoursesCore := Stages."Minimum Pass Core";
                end;


                ProgOptions.Reset;
                ProgOptions.SetFilter("Programme Code", GetFilter("Programme Filter"));
                ProgOptions.SetFilter(Code, GetFilter("Options Filter"));
                if ProgOptions.Find('-') then begin
                    if ProgOptions."Minmum Pass All" > 0 then MinUnits := ProgOptions."Minmum Pass All";
                    if ProgOptions."Minimum Pass Cores" > 0 then MinCoursesCore := ProgOptions."Minimum Pass Cores";
                end;

                if Prog.Get(GetFilter("Programme Filter")) then begin
                    PName := Prog.Description;
                    FDesc := Prog."School Code";
                    if MinUnits = 0 then MinUnits := Prog."Min No. of Courses";

                    FacultyR.Reset;
                    FacultyR.SetRange(FacultyR.Code, Prog."School Code");
                    if FacultyR.Find('-') then
                        FDesc := FacultyR.Name;

                    DValue.Reset;
                    DValue.SetRange(DValue.Code, Prog."Department Code");
                    DValue.SetRange(DValue."Dimension Code", 'DEPARTMENT');
                    if DValue.Find('-') then
                        Dept := DValue.Name;

                end;


                // Get the Units to be displayed----- Core
                CReg.Reset;
                CReg.CopyFilters("Course Registration");
                if CReg.Find('-') then begin
                    repeat
                        StudUnits.Reset;
                        //StudUnits.SETRANGE("Unit Type",StudUnits."Unit Type"::Core);
                        StudUnits.SetRange("Student No.", CReg."Student No.");
                        StudUnits.SetFilter(StudUnits.Programme, GetFilter("Programme Filter"));
                        StudUnits.SetFilter(StudUnits."Unit Type LK", '%1', StudUnits."unit type lk"::Core);
                        StudUnits.SetFilter(StudUnits.Stage, StageFilter);
                        //StudUnits.SETFILTER(StudUnits.Semester,SemFilter);
                        StudUnits.SetFilter(StudUnits."Reg Option", GetFilter("Options Filter"));
                        StudUnits.SetFilter(StudUnits."Session Code", GetFilter(Session));
                        StudUnits.SetFilter(StudUnits."Campus Code", GetFilter("Course Registration"."Campus Filter"));
                        StudUnits.SetFilter(StudUnits."Creg Register for", '%1', StudUnits."creg register for"::Stage);
                        StudUnits.SetFilter(StudUnits."Cust Exist", '>%1', 0);
                        StudUnits.SetFilter(StudUnits."Creg Exists", '>%1', 0);
                        StudUnits.SetFilter(StudUnits."Total Score", '>%1', 0);
                        StudUnits.SetCurrentkey(Unit, Stage, "Unit Type");
                        if StudUnits.Find('-') then begin
                            repeat
                                StudUnits.CalcFields("School Code");
                                StudUnits.CalcFields("Programme Category");
                                if (CopyStr(StudUnits."Student No.", StrLen(StudUnits."Student No.") - 1, 2) < '16') or (Prog."School Code" <> 'SASS') or (StudUnits."Programme Category" <> StudUnits."programme category"::Undergraduate) then begin

                                    StudUnits.CalcFields("Total Score");
                                    StudUnits.CalcFields("Creg Exists");
                                    StudUnits.CalcFields("Cust Exist");

                                    mFound := false;
                                    for K := 1 to 200 do begin
                                        if UnitShow[K] = StudUnits.Unit then mFound := true;
                                    end;
                                    if (mFound = false) and (i < 200) then begin

                                        i := i + 1;
                                        UnitShow[i] := StudUnits.Unit;
                                        UnitShow2[i] := StudUnits."No. Of Units";
                                    end;
                                end;
                            until StudUnits.Next = 0;
                        end;
                        if i = 0 then i := 1;
                        K_Max := i;

                        // Get the Units to be displayed----- Required
                        StudUnits.Reset;
                        //StudUnits.SETRANGE("Unit Type",StudUnits."Unit Type"::Core);
                        StudUnits.SetRange("Student No.", CReg."Student No.");
                        StudUnits.SetFilter(StudUnits.Programme, GetFilter("Programme Filter"));
                        StudUnits.SetFilter(StudUnits."Unit Type LK", '%1', StudUnits."unit type lk"::Required);
                        StudUnits.SetFilter(StudUnits.Stage, StageFilter);
                        //StudUnits.SETFILTER(StudUnits.Semester,SemFilter);
                        StudUnits.SetFilter(StudUnits."Reg Option", GetFilter("Options Filter"));
                        StudUnits.SetFilter(StudUnits."Session Code", GetFilter(Session));
                        StudUnits.SetFilter(StudUnits."Campus Code", GetFilter("Course Registration"."Campus Filter"));
                        StudUnits.SetFilter(StudUnits."Creg Register for", '%1', StudUnits."creg register for"::Stage);
                        StudUnits.SetFilter(StudUnits."Cust Exist", '>%1', 0);
                        StudUnits.SetFilter(StudUnits."Creg Exists", '>%1', 0);
                        StudUnits.SetFilter(StudUnits."Total Score", '>%1', 0);
                        StudUnits.SetCurrentkey(Unit, Stage, "Unit Type");
                        if StudUnits.Find('-') then begin
                            repeat
                                StudUnits.CalcFields("School Code");
                                StudUnits.CalcFields("Programme Category");
                                if (CopyStr(StudUnits."Student No.", StrLen(StudUnits."Student No.") - 1, 2) < '16') or (Prog."School Code" <> 'SASS') or (StudUnits."Programme Category" <> StudUnits."programme category"::Undergraduate) then begin

                                    StudUnits.CalcFields("Total Score");
                                    StudUnits.CalcFields("Creg Exists");
                                    StudUnits.CalcFields("Cust Exist");
                                    mFound := false;
                                    for K := 1 to 200 do begin
                                        if UnitShow[K] = StudUnits.Unit then mFound := true;
                                    end;
                                    if (mFound = false) and (i < 200) then begin
                                        i := i + 1;
                                        UnitShow[i] := StudUnits.Unit;
                                        UnitShow2[i] := StudUnits."No. Of Units";
                                    end;
                                end;
                            until StudUnits.Next = 0;
                        end;
                        if i = 0 then i := 1;
                        K_Max := i;

                        // Get the Units to be displayed----- Elective
                        StudUnits.Reset;
                        //StudUnits.SETRANGE("Unit Type",StudUnits."Unit Type"::Elective);
                        StudUnits.SetRange("Student No.", CReg."Student No.");
                        StudUnits.SetFilter(StudUnits."Unit Type LK", '%1', StudUnits."unit type lk"::Elective);
                        StudUnits.SetFilter(StudUnits.Programme, GetFilter("Programme Filter"));
                        StudUnits.SetFilter(StudUnits.Stage, StageFilter);
                        //StudUnits.SETFILTER(StudUnits.Semester,SemFilter);
                        StudUnits.SetFilter(StudUnits."Reg Option", GetFilter("Options Filter"));
                        StudUnits.SetFilter(StudUnits."Session Code", GetFilter(Session));
                        StudUnits.SetFilter(StudUnits."Campus Code", GetFilter("Course Registration"."Campus Filter"));
                        StudUnits.SetFilter(StudUnits."Creg Register for", '%1', StudUnits."creg register for"::Stage);
                        StudUnits.SetFilter(StudUnits."Cust Exist", '>%1', 0);
                        StudUnits.SetFilter(StudUnits."Creg Exists", '>%1', 0);
                        StudUnits.SetFilter(StudUnits."Total Score", '>%1', 0);
                        StudUnits.SetCurrentkey(Unit, Stage, "Unit Type");
                        if StudUnits.Find('-') then begin
                            repeat
                                StudUnits.CalcFields("School Code");
                                StudUnits.CalcFields("Programme Category");
                                if (CopyStr(StudUnits."Student No.", StrLen(StudUnits."Student No.") - 1, 2) < '16') or (Prog."School Code" <> 'SASS') or (StudUnits."Programme Category" <> StudUnits."programme category"::Undergraduate) then begin
                                    StudUnits.CalcFields("Total Score");
                                    StudUnits.CalcFields("Creg Exists");
                                    StudUnits.CalcFields("Cust Exist");
                                    mFound := false;
                                    for K := 1 to 200 do begin
                                        if UnitShow[K] = StudUnits.Unit then mFound := true;
                                    end;
                                    if (mFound = false) and (i < 200) then begin
                                        i := i + 1;
                                        UnitShow[i] := StudUnits.Unit;
                                        UnitShow2[i] := StudUnits."No. Of Units";
                                    end;
                                end;
                            until StudUnits.Next = 0;
                        end;
                    until CReg.Next = 0;
                end;
                if i = 0 then i := 1;
                K_Max := i;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DMarks; DMarks)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dont Show Marks';
                    ToolTip = 'Specifies the value of the Dont Show Marks field.';
                }
                field(CheckCAT; CheckCAT)
                {
                    ApplicationArea = Basic;
                    Caption = 'Check if CATs and EXAMs Exists';
                    ToolTip = 'Specifies the value of the Check if CATs and EXAMs Exists field.';
                }
                field(ShowResit; ShowResit)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dont Show Re-Sit Units';
                    ToolTip = 'Specifies the value of the Dont Show Re-Sit Units field.';
                }
                field(ShowRegUnits; ShowRegUnits)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show All Registered Units';
                    ToolTip = 'Specifies the value of the Show All Registered Units field.';
                }
                field(CalStatistics; CalStatistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Statistics';
                    ToolTip = 'Specifies the value of the Calculate Statistics field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        Cust: Record Customer;
        ColumnH: array[80] of Text[100];
        ColumnH2: array[80] of Text[100];
        ColumnV: array[80] of Text[250];
        ColumnVM: array[80] of Text[30];
        ColumnVX: array[80] of Text[30];
        ColumnVA: array[80] of Text[30];
        ColumnSD: array[80] of Text[200];
        ColumnUN: array[80] of Text[200];
        i: Integer;
        j: Integer;
        SCount: Integer;
        UnitsRR: Record "Units/Subjects";
        uColumnV: array[80] of Text[30];
        sColumnV: array[80] of Text[30];
        Prog: Record "Programme";
        Stages: Record "Programme Stages";
        Grade: Text[150];
        Gradings: Record "Grading System Setup";
        Gradings2: Record "Grading System Setup";
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        LastRemark: Text[200];
        CCat: Text[30];
        TScore: Decimal;
        RUnits: Decimal;
        MissingM: Boolean;
        DValue: Record "Dimension Value";
        FDesc: Text[200];
        Dept: Text[200];
        PName: Text[200];
        SDesc: Text[200];
        Comb: Text[200];
        DMarks: Boolean;
        DSummary: Boolean;
        CReg: Record "Course Registration";
        UTaken: Integer;
        UPassed: Integer;
        UFailed: Integer;
        MCourse: Boolean;
        StudUnits: Record "Student Units";
        CAve: Decimal;
        GradeCategory: Code[20];
        ProgrammeRec: Record "Programme";
        GLabel: array[6] of Code[20];
        GLabel2: array[6] of Code[100];
        FacultyR: Record "Dimension Value";
        TReg: Integer;
        CheckCAT: Boolean;
        AvScore: array[80] of Decimal;
        AvScoreCount: array[80] of Decimal;
        STD: array[81] of Decimal;
        GenSetup: Record "General Set-Up";
        Sem: Record Semesters;
        SemYear: Code[100];
        ShowResit: Boolean;
        ResultStatus: Record "Results Status";
        SMM: array[20] of Text[100];
        School_CaptionLbl: label 'School:';
        Department_CaptionLbl: label 'Department:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Stage_CaptionLbl: label 'Stage:';
        Academic_Year_CaptionLbl: label 'Academic Year:';
        Consolidated_MarksheetCaptionLbl: label 'Consolidated Marksheet';
        Semester_CaptionLbl: label 'Semester:';
        Registration_No_CaptionLbl: label 'Registration No.';
        NamesCaptionLbl: label 'Names';
        UNITS__CaptionLbl: label 'UNITS=>';
        EmptyStringCaptionLbl: label '#';
        Units_Key_CaptionLbl: label 'Units Key:';
        Approved_by_the_Departmental_Board_of_ExaminersCaptionLbl: label 'Approved by the Departmental Board of Examiners';
        Approved_by_the_School_Board_of_ExaminersCaptionLbl: label 'Approved by the School Board of Examiners';
        Signed_______________________________________CaptionLbl: label 'Signed:______________________________________';
        Signed_______________________________________Caption_Control1102755449Lbl: label 'Signed:______________________________________';
        Signed_______________________________________Caption_Control1102755450Lbl: label 'Signed:______________________________________';
        Approved_by_DeKUT_SenateCaptionLbl: label 'Approved by DeKUT Senate';
        Chairperson_of_DepartmentCaptionLbl: label 'Chairperson of Department';
        AG_VC_DeKUTCaptionLbl: label 'AG.VC DeKUT';
        Guide_on_Remarks_CaptionLbl: label 'Guide on Remarks:';
        Guide_on_remarks_Caption_Control1102760087Lbl: label 'Guide on remarks:';
        Total_Reg_CaptionLbl: label 'Total Reg.';
        Mean_ScoreCaptionLbl: label 'Mean Score';
        Maximum_ScoreCaptionLbl: label 'Maximum Score';
        Minimum_ScoreCaptionLbl: label 'Minimum Score';
        Units_Key_Caption_Control1102755384Lbl: label 'Units Key:';
        Approved_by_the_Departmental_Board_of_ExaminersCaption_Control1000000009Lbl: label 'Approved by the Departmental Board of Examiners';
        Approved_by_the_School_Board_of_ExaminersCaption_Control1000000010Lbl: label 'Approved by the School Board of Examiners';
        Signed_______________________________________Caption_Control1000000011Lbl: label 'Signed:______________________________________';
        Signed_______________________________________Caption_Control1000000012Lbl: label 'Signed:______________________________________';
        Signed_______________________________________Caption_Control1000000013Lbl: label 'Signed:______________________________________';
        Approved_by_DeKUT_SenateCaption_Control1000000014Lbl: label 'Approved by DeKUT Senate';
        Chairperson_of_DepartmentCaption_Control1000000015Lbl: label 'Chairperson of Department';
        Chairperson_SenateCaptionLbl: label 'Chairperson Senate';
        Standard_DeviationCaptionLbl: label 'Standard Deviation';
        CompInf: Record "Company Information";
        UnitNo: Text;
        YearDesc: Code[20];
        CFTotal: Decimal;
        //  OptionsComb: Record "Units Options Combination";
        ColumnG: array[10] of Code[20];
        ColumnGV: array[60] of Code[20];
        ColumnGV1: array[30] of Code[20];
        ColumnGV2: array[30] of Code[20];
        ColumnGV3: array[30] of Code[20];
        ColumnGV4: array[30] of Code[20];
        ColumnGV5: array[30] of Code[20];
        ColumnGV6: array[30] of Code[20];
        ColumnGV7: array[30] of Code[20];
        ShowRegUnits: Boolean;
        ExamProc: Codeunit "Exams Processing";
        FailedUnits: Text[250];
        FailPerc: Decimal;
        UnitShow: array[800] of Code[200];
        UnitShow2: array[800] of Decimal;
        K: Integer;
        mFound: Boolean;
        K_Max: Integer;
        SemFilter: Text[200];
        StageFilter: Text[200];
        StudyYear: Record "Study Years";
        SemFilter2: Text[200];
        CalStatistics: Boolean;
        StageFilter2: Text[200];
        MinUnits: Decimal;
        MinCoursesCore: Decimal;
        ProgOptions: Record "Programme Options";
        Yr1Av: Decimal;
        Yr2Av: Decimal;
        Yr3Av: Decimal;
        Yr4Av: Decimal;
        Yr5Av: Decimal;
        Yr1W: Decimal;
        Yr2W: Decimal;
        Yr3W: Decimal;
        Yr4W: Decimal;
        Yr1U: Decimal;
        Yr2U: Decimal;
        Yr3U: Decimal;
        Yr4U: Decimal;
        AverageMarks: Decimal;

    procedure GetGrade(Marks: Decimal; ProG: Code[20]; UnitG: Code[20]) xGrade: Text[100]
    begin
        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", "Course Registration".Programme);
        UnitsRR.SetRange(UnitsRR.Code, UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code", "Course Registration".Stage);
        if (UnitsRR.Find('-')) and (UnitsRR."Default Exam Category" <> '') then begin
            GradeCategory := UnitsRR."Default Exam Category";
        end else begin
            ProgrammeRec.Reset;
            if ProgrammeRec.Get("Course Registration".Programme) then
                GradeCategory := ProgrammeRec."Exam Category";
            if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;

        xGrade := '';
        if Marks > 0 then begin
            Gradings.Reset;
            Gradings.SetRange(Gradings.Category, GradeCategory);
            LastGrade := '';
            LastRemark := '';
            LastScore := 0;
            if Gradings.Find('-') then begin
                ExitDo := false;
                repeat
                    LastScore := Gradings."Up to";
                    if Marks < LastScore then begin
                        if ExitDo = false then begin
                            xGrade := Gradings.Grade;
                            if Gradings.Failed = false then
                                LastRemark := 'PASS'
                            else
                                LastRemark := 'FAIL';
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin
            Grade := '';
            //Remarks:='Not Done';
        end;
    end;

    procedure GetGradeStatus(var AvMarks: Decimal; var ProgCode: Code[20]; var Unit: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record "Grading System Setup";
        GradeCategory: Code[20];
        ProgrammeRec: Record "Programme";
        Grd: Code[80];
    begin
        F := false;

        GradeCategory := '';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code", ProgCode);
        UnitsRR.SetRange(UnitsRR.Code, Unit);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Course Registration".Stage);
        if UnitsRR.Find('-') then begin
            if UnitsRR."Default Exam Category" <> '' then begin
                GradeCategory := UnitsRR."Default Exam Category";
            end else begin
                ProgrammeRec.Reset;
                if ProgrammeRec.Get(ProgCode) then
                    GradeCategory := ProgrammeRec."Exam Category";
                if GradeCategory = '' then Error('Please note that you must specify Exam Category in Programme Setup');
            end;
        end;

        if AvMarks > 0 then begin
            Gradings.Reset;
            Gradings.SetRange(Gradings.Category, GradeCategory);
            LastGrade := '';
            LastRemark := '';
            LastScore := 0;
            if Gradings.Find('-') then begin
                ExitDo := false;
                repeat
                    LastScore := Gradings."Up to";
                    if AvMarks < LastScore then begin
                        if ExitDo = false then begin
                            Grd := Gradings.Grade;
                            F := Gradings.Failed;
                            ExitDo := true;
                        end;
                    end;

                until Gradings.Next = 0;


            end;

        end else begin


        end;
    end;

    local procedure CheckPassAllYears(StudentNo: Code[20]; StudProgramme: Code[20]; YearsDone: Code[20]) Pass: Boolean
    var
        MinYearUnits: Decimal;
        ExemptedU: Decimal;
    begin

        Pass := true;
        CReg.Reset;
        CReg.SetRange("Student No.", StudentNo);
        CReg.SetRange(Programme, StudProgramme);
        CReg.SetRange(Stage, 'Y4S1');
        if CReg.Find('-') then begin
            ExemptedU := CReg."Exempted Units";
        end;
        if ExemptedU = 0 then begin
            CReg.Reset;
            CReg.SetRange("Student No.", StudentNo);
            CReg.SetRange(Programme, StudProgramme);
            CReg.SetRange(Stage, 'Y2S1');
            if CReg.Find('-') then begin
                ExemptedU := CReg."Exempted Units";
            end;
        end;

        if Prog.Get(StudProgramme) then
            MinYearUnits := Prog."Minimum Units Per Year";
        if YearsDone = '1' then begin
            Stages.Reset;
            Stages.SetRange(Code, 'Y1S1');
            Stages.SetRange("Programme Code", StudProgramme);
            if Stages.Find('-') then begin
                if Stages."Minimum Pass All" > 0 then MinYearUnits := Stages."Minimum Pass All";
                CReg.Reset;
                CReg.SetRange("Student No.", StudentNo);
                CReg.SetRange(Programme, StudProgramme);
                CReg.SetFilter("Stage Filter", '%1..%2', 'Y1S1', 'Y1S2');
                if CReg.Find('-') then begin
                    CReg.CalcFields("Cum Units Passed Cores");
                    CReg.CalcFields("Cum Units Passed");
                    CReg.CalcFields("CF Count");
                    CReg.CalcFields("CF Total Score");
                    if (CReg."CF Count" > 0) and (CReg."CF Total Score" > 0) then Yr1Av := (CReg."CF Total Score" / CReg."CF Count");
                    Yr1U := CReg."CF Count";
                    Yr1W := CReg."CF Total Score";
                    if CReg."Cum Units Passed Cores" + ExemptedU < Stages."Minimum Pass Core" then Pass := false;
                    // IF CReg."Cum Units Passed"<Stages."Minimum Pass All" THEN Pass:=FALSE;
                    if (CReg."CF Count" + ExemptedU) < MinYearUnits then Pass := false;
                end;
            end;
        end;


        if (YearsDone = '2') then begin
            Stages.Reset;
            Stages.SetRange(Code, 'Y2S1');
            Stages.SetRange("Programme Code", StudProgramme);
            if Stages.Find('-') then begin
                if Stages."Minimum Pass All" > 0 then MinYearUnits := Stages."Minimum Pass All";
                CReg.Reset;
                CReg.SetRange("Student No.", StudentNo);
                CReg.SetRange(Programme, StudProgramme);
                CReg.SetFilter("Stage Filter", 'Y2S1..Y2S2');
                if CReg.Find('-') then begin
                    CReg.CalcFields("Cum Units Passed Cores");
                    CReg.CalcFields("Cum Units Passed");
                    CReg.CalcFields("CF Count");
                    CReg.CalcFields("CF Total Score");
                    if (CReg."CF Count" <> 0) and (CReg."CF Total Score" <> 0) then Yr2Av := (CReg."CF Total Score" / CReg."CF Count");
                    Yr2U := CReg."CF Count";
                    Yr2W := CReg."CF Total Score";
                    if CReg."Cum Units Passed Cores" + ExemptedU < Stages."Minimum Pass Core" then Pass := false;
                    if (CReg."CF Count" + ExemptedU) < MinYearUnits then Pass := false;
                    // IF CReg."Cum Units Passed"<Stages."Minimum Pass All" THEN Pass:=FALSE;
                end;
            end;
        end;

        if (YearsDone = '3') then begin
            Stages.Reset;
            Stages.SetRange(Code, 'Y3S1');
            Stages.SetRange("Programme Code", StudProgramme);
            if Stages.Find('-') then begin
                if Stages."Minimum Pass All" > 0 then MinYearUnits := Stages."Minimum Pass All";
                CReg.Reset;
                CReg.SetRange("Student No.", StudentNo);
                CReg.SetRange(Programme, StudProgramme);
                CReg.SetFilter("Stage Filter", 'Y3S1..Y3S2');
                if CReg.Find('-') then begin
                    CReg.CalcFields("Cum Units Passed Cores");
                    CReg.CalcFields("Cum Units Passed");
                    CReg.CalcFields("CF Count");
                    CReg.CalcFields("CF Total Score");
                    if (CReg."CF Count" <> 0) and (CReg."CF Total Score" <> 0) then Yr3Av := (CReg."CF Total Score" / CReg."CF Count");
                    Yr3U := CReg."CF Count";
                    Yr3W := CReg."CF Total Score";
                    if CReg."Cum Units Passed Cores" < Stages."Minimum Pass Core" then Pass := false;
                    if (CReg."CF Count") < MinYearUnits then Pass := false;
                    // IF CReg."Cum Units Passed"<Stages."Minimum Pass All" THEN Pass:=FALSE;
                end;
            end;
        end;
        //ERROR('Test3'+FORMAT(Pass));
        if (YearsDone = '4') then begin
            Stages.Reset;
            Stages.SetRange(Code, 'Y4S1');
            Stages.SetRange("Programme Code", StudProgramme);
            if Stages.Find('-') then begin
                if Stages."Minimum Pass All" > 0 then MinYearUnits := Stages."Minimum Pass All";
                CReg.Reset;
                CReg.SetRange("Student No.", StudentNo);
                CReg.SetRange(Programme, StudProgramme);
                CReg.SetFilter("Stage Filter", 'Y4S1..Y4S2');
                if CReg.Find('-') then begin
                    CReg.CalcFields("Cum Units Passed Cores");
                    CReg.CalcFields("Cum Units Passed");
                    CReg.CalcFields("CF Count");
                    CReg.CalcFields("CF Total Score");
                    if (CReg."CF Count" <> 0) and (CReg."CF Total Score" <> 0) then Yr4Av := (CReg."CF Total Score" / CReg."CF Count");
                    Yr4U := CReg."CF Count";
                    Yr4W := CReg."CF Total Score";
                    if CReg."Cum Units Passed Cores" < Stages."Minimum Pass Core" then Pass := false;
                    //IF CReg."Cum Units Passed"<Stages."Minimum Pass All" THEN Pass:=FALSE;
                    if (CReg."CF Count") < MinYearUnits then Pass := false;
                end;
            end;
        end;

        if (YearsDone = '5') then begin
            Stages.Reset;
            Stages.SetRange(Code, 'Y5S1');
            Stages.SetRange("Programme Code", StudProgramme);
            if Stages.Find('-') then begin
                CReg.Reset;
                CReg.SetRange("Student No.", StudentNo);
                CReg.SetRange(Programme, StudProgramme);
                CReg.SetFilter("Stage Filter", 'Y5S1..Y5S2');
                if CReg.Find('-') then begin
                    CReg.CalcFields("Cum Units Passed Cores");
                    CReg.CalcFields("Cum Units Passed");
                    CReg.CalcFields("CF Count");
                    CReg.CalcFields("CF Total Score");
                    if (CReg."CF Count" <> 0) and (CReg."CF Total Score" <> 0) then Yr5Av := (CReg."CF Total Score" / CReg."CF Count");

                    if CReg."Cum Units Passed Cores" < Stages."Minimum Pass Core" then Pass := false;
                    if (CReg."CF Count") < MinYearUnits then Pass := false;
                    // IF CReg."Cum Units Passed"<Stages."Minimum Pass All" THEN Pass:=FALSE;
                end;
            end;

            //AverageMarks:=Yr1Av+Yr2Av+Yr3Av+Yr4Av;
            //IF AverageMarks>0 THEN AverageMarks:=AverageMarks/4;
        end;
        //Overal
        CReg.Reset;
        CReg.SetRange("Student No.", StudentNo);
        CReg.SetRange(Programme, StudProgramme);
        CReg.SetFilter("Stage Filter", 'Y1S1..Y5S2');
        if CReg.Find('-') then begin
            CReg.CalcFields("Cum Units Passed Cores");
            CReg.CalcFields("CF Count");
            CReg.CalcFields("CF Total Score");
            if (CReg."CF Count" <> 0) and (CReg."CF Total Score" <> 0) then AverageMarks := (CReg."CF Total Score" / CReg."CF Count");
        end;
        //IF (Yr1Av=0) OR (Yr2Av=0) OR (Yr3Av=0) OR (Yr4Av=0) THEN Pass:=FALSE;
    end;
}

