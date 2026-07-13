Page 50689 "HMS Setup Doctor Card"
{
    PageType = Card;
    SourceTable = "HMS Setup Doctor";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(DoctorID; Rec."Doctor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctor ID field.';
                }
                field(DoctorsName; Rec."Doctors Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Doctors Name field.';
                }
                field(ConsultationCode; Rec."Consultation Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Consultation Code field.';
                }
                field(CommissionPerc; Rec."Commission Perc")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commission Perc field.';
                }
                field(Specialization; Rec.Specialization)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Specialization field.';
                }
                field(Telephone; Rec.Telephone)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone field.';
                }
                field(ProffesionalRegistrationNo; Rec."Proffesional Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Proffesional Registration No. field.';
                }
                field(Resident; Rec.Resident)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resident field.';
                }
                field("TIN No"; Rec."PIN No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(HDF; Rec."HDF%")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HDF% field.';
                }
                field(InsuranceNoFilter; Rec."Insurance No. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Insurance No. Filter field.';
                }
                field(PendingAmount; Rec."Pending Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pending Amount field.';
                }
                field(CompletedFilter; Rec."Completed Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Completed Filter field.';
                }
                field(OpenCharges; Rec."Open Charges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Open Charges field.';
                }
                field(ClaimedCharges; Rec."Claimed Charges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claimed Charges field.';
                }
                field(DateFilter; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
                field(ConsultationCodeCash; Rec."Consultation Code Cash")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Consultation Code Cash field.';
                }
            }
        }
    }

    actions { }
}

