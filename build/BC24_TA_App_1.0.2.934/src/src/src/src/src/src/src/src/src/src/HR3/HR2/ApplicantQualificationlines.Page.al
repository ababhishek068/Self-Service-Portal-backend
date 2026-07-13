Page 51172 "Applicant Qualification lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Applicant Qualification Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Qualificationcode; Rec."Qualification code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification code field.';
                }
                field(QualificationDescription; Rec."Qualification Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Description field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';

                    trigger OnValidate()
                    begin
                        if (Rec."To Date" <> 0D) and (Rec."From Date" <> 0D) then
                            Rec."No of Years" := Rec."To Date" - Rec."From Date";
                    end;
                }
                field(Institution; Rec.Institution)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution field.';
                }
                field(QualificationType; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(Noofdays; Rec."No of Years")
                {
                    ApplicationArea = Basic;
                    Caption = 'No of days';
                    Editable = false;
                    ToolTip = 'Specifies the value of the No of days field.';
                }
                field(ActualScore; Rec."Actual Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Score field.';
                }
                field(DesiredScore; Rec."Desired Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Desired Score field.';
                }
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualified field.';
                }
            }
        }
    }

    actions { }
}

