page 50121 Audit
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Audits;
    CardPageId = "Audit Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Audit No."; Rec."Audit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit No. field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Audit Programme"; Rec."Audit Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit Programme field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("Leaders Appointment Date"; Rec."Leaders Appointment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Leaders Appointment Date field.';

                }
                field("Members Appointment Date"; Rec."Members Appointment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Members Appointment Date field.';

                }
                field("Audit From Date"; Rec."Audit From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit From Date field.';

                }
                field("Audit To Date"; Rec."Audit To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Audit To Date field.';

                }
                field("Follow Up From Date"; Rec."Follow Up From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Follow Up From Date field.';

                }
                field("Follow Up To Date"; Rec."Follow Up To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Follow Up To Date field.';

                }
                field("Review To Date"; Rec."Review To Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Review To Date field.';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}