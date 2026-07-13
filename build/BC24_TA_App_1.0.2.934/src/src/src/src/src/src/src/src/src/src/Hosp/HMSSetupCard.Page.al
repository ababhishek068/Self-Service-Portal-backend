Page 50688 "HMS Setup Card"
{
    PageType = Card;
    SourceTable = "HMS Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PatientNos; Rec."Patient Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Nos field.';
                }
                field(AppointmentNos; Rec."Appointment Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appointment Nos field.';
                }
                field(ObservationNos; Rec."Observation Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Nos field.';
                }
                field(VisitNos; Rec."Visit Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visit Nos field.';
                }
                field(LaboratoryTestNos; Rec."Lab Test Request Nos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Test Nos';
                    ToolTip = 'Specifies the value of the Laboratory Test Nos field.';
                }
                field(RadiologyNos; Rec."Radiology Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Radiology Nos field.';
                }
                field(PharmacyNos; Rec."Pharmacy Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Nos field.';
                }
                field(AdmissionRequestNos; Rec."Admission Request Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Request Nos field.';
                }
                field(ReferralNos; Rec."Referral Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Referral Nos field.';
                }
                field("Portal Reports Path"; Rec."Portal Reports Path")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Portal Reports Path field.';
                }
            }
            group(Pharmacies)
            {
                Caption = 'Pharmacies';
                field(PharmacyItemJournalTemplate; Rec."Pharmacy Item Journal Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Item Journal Template field.';
                }
                field(PharmacyItemJournalBatch; Rec."Pharmacy Item Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Item Journal Batch field.';
                }
                field(PharmacyLocation; Rec."Pharmacy Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Location field.';
                }
                field(PharmacyGLAccount; Rec."Pharmacy G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy G/L Account field.';
                }
                field(ObservationRoom; Rec."Observation Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Room field.';
                }
                field(ObservationItemJournalTemp; Rec."Observation Item Journal Temp")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Item Journal Temp field.';
                }
                field(ObservationItemJournalBatch; Rec."Observation Item Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Item Journal Batch field.';
                }
                field(DoctorRoom; Rec."Doctor Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor Room field.';
                }
                field(DoctorItemJournalTemplate; Rec."Doctor Item Journal Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor Item Journal Template field.';
                }
                field(DoctorItemJournalBatch; Rec."Doctor Item Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor Item Journal Batch field.';
                }
                field(LaboratoryRoom; Rec."Laboratory Room")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Room field.';
                }
                field(LaboratoryItemJournalTemp; Rec."Laboratory Item Journal Temp")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Item Journal Temp field.';
                }
                field(LaboratoryItemJournalBatch; Rec."Laboratory Item Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Item Journal Batch field.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(BillStudents; Rec."Bill Students")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bill Students field.';
                }
                field(BillEmployees; Rec."Bill Employees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bill Employees field.';
                }
                field(BillOtherCategories; Rec."Bill Other Categories")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bill Other Categories field.';
                }
                field(LimitOfNextOfKin; Rec."Limit Of Next Of Kin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Limit Of Next Of Kin field.';
                }
                field(LimitAgeOfNextOfKinYrs; Rec."Limit Age Of Next Of Kin(Yrs)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Limit Age Of Next Of Kin(Yrs) field.';
                }
            }
        }
    }

    actions { }
}

