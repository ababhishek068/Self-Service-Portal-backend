Page 51445 "HR Medical Scheme Members Card"
{
    PageType = Card;
    SourceTable = "HR Medical Scheme Members";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(EmployeeNo; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(SchemeJoinDate; Rec."Scheme Join Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme Join Date field.';
                }
                field(SchemeAnniversary; Rec."Scheme Anniversary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme Anniversary field.';
                }
                field(OutPatientLimit; Rec."Out-Patient Limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Out-Patient Limit field.';
                }
                field("Member No"; Rec."Member No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Member No field.';
                }
                field(CummAmountSpentOut; Rec."Cumm.Amount Spent Out")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cumm.Amount Spent Out field.';
                }
                field(BalanceOutPatient; Rec."Balance Out- Patient")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance Out- Patient field.';
                }
                field(InpatientLimit; Rec."In-patient Limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the In-patient Limit field.';
                }
                field(CummAmountSpent; Rec."Cumm.Amount Spent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cumm.Amount Spent field.';
                }
                field(BalanceInPatient; Rec."Balance In- Patient")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance In- Patient field.';
                }
                field(MaximumCover; Rec."Maximum Cover")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Cover field.';
                }
            }
            part(Control1102755008; "HR Medical Dependant")
            {
                SubPageLink = "Scheme No" = field("Scheme No"), "Employee No" = field("Employee No");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(MedicalClaims)
                {
                    ApplicationArea = Basic;
                    Caption = 'Medical Claims';
                    Image = PersonInCharge;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Medical Claims action.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Medscheme.Reset;
        Medscheme.SetRange(Medscheme."Scheme No", Rec."Scheme No");
        if Medscheme.Find('-') then begin
            Rec."Out-Patient Limit" := Medscheme."Out-patient limit";
            Rec."In-patient Limit" := Medscheme."In-patient limit";
            Rec."Balance In- Patient" := Rec."In-patient Limit" - Rec."Cumm.Amount Spent";
            Rec."Balance Out- Patient" := Rec."Out-Patient Limit" - Rec."Cumm.Amount Spent Out";
        end;
    end;

    trigger OnInit()
    begin

        Medscheme.Reset;
        Medscheme.SetRange(Medscheme."Scheme No", Rec."Scheme No");
        if Medscheme.Find('-') then begin
            Rec."Out-Patient Limit" := Medscheme."Out-patient limit";
            Rec."In-patient Limit" := Medscheme."In-patient limit";
            Rec."Balance In- Patient" := Rec."In-patient Limit" - Rec."Cumm.Amount Spent";
            Rec."Balance Out- Patient" := Rec."Out-Patient Limit" - Rec."Cumm.Amount Spent Out";
        end;
    end;

    trigger OnOpenPage()
    begin
        Medscheme.Reset;
        Medscheme.SetRange(Medscheme."Scheme No", Rec."Scheme No");
        if Medscheme.Find('-') then begin
            Rec."Out-Patient Limit" := Medscheme."Out-patient limit";
            Rec."In-patient Limit" := Medscheme."In-patient limit";
            Rec."Balance In- Patient" := Rec."In-patient Limit" - Rec."Cumm.Amount Spent";
            Rec."Balance Out- Patient" := Rec."Out-Patient Limit" - Rec."Cumm.Amount Spent Out";
        end;
    end;

    var
        Medscheme: Record "HR Medical Schemes";
}

