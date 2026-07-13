Page 50534 "Procurement Plan"
{
    Caption = 'Procurement Plan ';
    PageType = Card;
    SourceTable = "Procurement Plan Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BudgetName; Rec."Budget Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Name field.';
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.';
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.';

                    trigger OnValidate()
                    begin
                        Dim.Reset;
                        Dim.SetRange(Dim.Code, Rec."Global Dimension 1");
                        if Dim.Find('-') then begin
                            DptName := Dim.Name;
                        end;
                    end;
                }
                field(DptName; DptName)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the DptName field.';
                }
                field(ProcurementPlanPeriod; Rec."Procurement Plan Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Plan Period field.';
                }
            }
            part(Control1102755005; "Procurement Plan Lines")
            {
                ApplicationArea = basic;
                SubPageLink = "Budget Name" = field("Budget Name"),
                              "Global Dimension 1" = field("Global Dimension 1"),
                              "Global Dimension 2" = field("Global Dimension 2"),
                              "Procurement Plan Period" = field("Procurement Plan Period");
            }
        }
    }

    actions { }

    var
        DptName: Text[50];
        Dim: Record "Dimension Value";
}

