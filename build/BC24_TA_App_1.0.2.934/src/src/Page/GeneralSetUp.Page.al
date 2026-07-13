Page 50193 "General Set-Up"
{
    PageType = Card;
    SourceTable = "General Set-Up";
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Numbering';
                field(StudentNos; Rec."Student Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Nos. field.';
                }
                field(AdmissionNos; Rec."Admission Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Nos. field.';
                }
                field(RegistrationNos; Rec."Registration Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registration Nos. field.';
                }
                field(TransactionNos; Rec."Transaction Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Nos. field.';
                }
                field(ReceiptNos; Rec."Receipt Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Nos. field.';
                }
                field(ClassAllocationNos; Rec."Class Allocation Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Allocation Nos. field.';
                }
                field(BatchReceiptsNos; Rec."Batch Receipts Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Batch Receipts Nos field.';
                }
                field(MedicalConditionNos; Rec."Medical Condition Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Condition Nos field.';
                }
                field(AttachmentNos; Rec."Attachment Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attachment Nos field.';
                }
                field(EnquiryNos; Rec."Enquiry Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Enquiry Nos field.';
                }
                field(ClearanceNos; Rec."Clearance Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Clearance Nos field.';
                }
                field(MarksApprovalNos; Rec."Marks Approval Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marks Approval Nos field.';
                }
                field(ProgrammeCapDeclarationNos; Rec."Programme Cap.Declaration Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Cap.Declaration Nos. field.';
                }
                field(ProformaNos; Rec."Proforma Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proforma Nos field.';
                }
                field("Student Scolorship Nos."; Rec."Student Scolorship Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Scolorship Nos. field.';
                }
                field("Graduation Request Nos."; Rec."Graduation Request Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Graduation Request Nos. field.';
                }

            }
            group("Invoicing")
            {
                field(DeferedAccount; Rec."Defered Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Defered Account field.';
                }
                field(OverPaymentAccount; Rec."Over Payment Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Over Payment Account field.';
                }

                field(PrePaymentAccount; Rec."Pre-Payment Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pre-Payment Account field.';
                }
                field("Payment Plan Mandatory"; Rec."Payment Plan Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Plan Mandatory field.';
                }
                field("Penalty Charge Code"; Rec."Penalty Charge Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Penalty Charge Code field.';
                }
                field("Penalize Late Payment"; Rec."Penalize Late Payment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Penalize Late Payment field.';
                }
                field("Unit Billing Type"; Rec."Unit Billing Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Billing Type field.';
                }
                field(BillSupplimentaryFee; Rec."Bill Supplimentary Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bill Supplimentary Fee field.';
                }
                field(SupplimentaryFeeCode; Rec."Supplimentary Fee Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supplimentary Fee Code field.';
                }
                field(SupplimentrayFees; Rec."Supplimentray Fees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supplimentray Fees field.';
                }
                field(UnallocatedRcptsAccount; Rec."Unallocated Rcpts Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unallocated Rcpts Account field.';
                }

                field(ApplicationFee; Rec."Application Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Application Fee field.';
                }
                field(HelbAccount; Rec."Helb Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Helb Account field.';
                }
                field(CDFAccount; Rec."CDF Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CDF Account field.';
                }
            }
            group(Controls)
            {
                caption = 'General Controls';
                field(AllowPostingFrom; Rec."Allow Posting From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Posting From field.';
                }
                field(AllowPostingTo; Rec."Allow Posting To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Posting To field.';
                }
                field(ApplicationsDateLine; Rec."Applications Date Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applications Date Line field.';
                }
                field(DefaultSemester; Rec."Default Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Semester field.';
                }
                field(DefaultYear; Rec."Default Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Year field.';
                }
                field(DefaultIntake; Rec."Default Intake")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Intake field.';
                }
                field(DefaultAcademicYear; Rec."Default Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Academic Year field.';
                }

                field("Students Enquiry Nos."; Rec."Students Enquiry Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Students Enquiry Nos. field.';
                }



                field("KUCCPS Settlement Type"; Rec."KUCCPS Settlement Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the KUCCPS Settlement Type field.';
                }
                field("Exemption Semester"; Rec."Exemption Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exemption Semester field.';
                }
                field("Exemption Grade"; Rec."Exemption Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exemption Grade field.';
                }
                field(AllowUnPaidHostelBooking; Rec."Allow UnPaid Hostel Booking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow UnPaid Hostel Booking field.';
                }
                field("Fee Control Type"; Rec."Fee Control Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fee Control Type field.';
                }

                field(AllowedRegFeesPerc; Rec."Allowed Reg. Fees Perc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allowed Reg. Fees Perc. field.';
                }
                field(AllowOnlineResultsAccess; Rec."Allow Online Results Access")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Online Results Access field.';
                }
                field("Results Release Type"; Rec."Results Release Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Results Release Type field.';
                }
                field("Allow Hostel Booking"; Rec."Allow Hostel Booking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Hostel Booking field.';
                }
                field("Allow Only Y1"; Rec."Allow Only Y1")
                {
                    caption = 'Allow Only first year(Hostel booking)';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Only first year(Hostel booking) field.';
                }
                field("Allow Student Transfer Req"; Rec."Allow Student Transfer Req")
                {
                    caption = 'Allow Student Transfer Application';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Student Transfer Application field.';
                }

                field("Prog. Transfer Approval Date"; Rec."Prog. Transfer Approval Date")
                {
                    caption = 'Programme Transfer Approval Date';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme Transfer Approval Date field.';
                }
                field("Allow Student Clearance Req"; Rec."Allow Student Clearance Req")
                {
                    caption = 'Allow Student Clearance Application';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Student Clearance Application field.';
                }
                field("Allow Graduation Application"; Rec."Allow Graduation Application")
                {
                    caption = 'Allow Student Graduation Application';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Student Graduation Application field.';
                }
                field(MaxHostelBookingPeriod; Rec."Max Hostel Booking Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Hostel Booking Period field.';
                }
                field("Generate Reg No (KUCCPS)"; Rec."Generate Reg No (KUCCPS)")
                {
                    Caption = 'Generate Reg No (KUCCPS) On Processing';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Generate Reg No (KUCCPS) On Processing field.';
                }
                field("Re-Generate Reg No (KUCCPS)"; Rec."Re-Generate Reg No (KUCCPS)")
                {
                    Caption = 'Generate Reg No (KUCCPS) On Admission';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Generate Reg No (KUCCPS) On Admission field.';
                }
                field("Allow Units Validation"; Rec."Allow Units Validation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Units Validation field.';
                }
                field("Use Campus Prefix on Admission"; Rec."Use Campus Prefix on Admission")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Use Campus Prefix on Admission field.';
                }
                field("Default Class"; Rec."Default Class")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Class field.';
                }
                field("Allow AutoProgression Stage"; Rec."Allow AutoProgression Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow AutoProgression Stage field.';
                }
                field("Class Attendance Mandatory"; Rec."Class Attendance Mandatory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Attendance Mandatory field.';
                }
                field("Manual Class Generation"; Rec."Manual Class Generation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Manual Class Generation field.';
                }
                field("Exam Grading Type"; Rec."Exam Grading Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exam Grading Type field.';
                }
                field("Registration Number Seperator"; Rec."Registration Number Seperator")
                {

                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Registration Number Seperator field.';
                }
                field("Notify Student on Invoice"; Rec."Notify Student on Invoice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notify Student on Invoice field.';
                }
                field("Notify Student on Receipt"; Rec."Notify Student on Receipt")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notify Student on Receipt field.';
                }
                field("Notify on Due Payments"; Rec."Notify on Due Payments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notify on Due Payments field.';
                }
                field("Students Portal Portal URL"; Rec."Students Portal Portal URL")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Students Portal Portal URL field.';
                }
                field("Portal Reports File Path"; Rec."Portal Reports File Path")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Portal Reports File Path field.';
                }
                field("Portal Attachment File Path"; Rec."Portal Attachment File Path")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Portal Attachment File Path field.';
                }


            }
            group(IDSetup)
            {
                Caption = 'ID Setup';
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signature';
                    ToolTip = 'Specifies the value of the Signature field.';
                }
                field(Logo; Rec."Bar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bar Code field.';
                }
            }
        }
    }


}

