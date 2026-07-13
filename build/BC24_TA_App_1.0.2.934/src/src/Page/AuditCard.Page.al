page 50122 "Audit Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Audits;

    layout
    {
        area(Content)
        {
            group(GroupName)
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
            group(Auditors)
            {
                part(Audito; Auditors)
                {
                    ApplicationArea = basic;
                    SubPageLink = "Audit Code" = field(Code);
                }
            }
            group(CheckList)
            {
                part(Checklis; "Audit CheckList")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Audit Code" = field(Code);
                }
            }
            group(Findings)
            {
                part(Finding; "Audit Finding Action")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Code" = field(Code);
                }
            }


        }
    }

    actions
    {
        area(Processing)
        {
            action(Meetings)
            {
                caption = 'Meetings';
                ApplicationArea = All;
                RunObject = page "Audit Meetings";
                RunPageLink = "Audit Programme" = field(Code);
                ToolTip = 'Executes the Meetings action.';

            }
        }
    }
}