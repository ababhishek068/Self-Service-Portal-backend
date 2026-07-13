page 50258 "Deployment Confirmation List"
{
    Caption = 'Safe Arrival';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deployment Request";
    CardPageId = "Deployment Confirmation Card";
    SourceTableView = where(Status = filter(Approved), "Project Status" = filter(Active));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Requested Service M/W"; Rec."Requested Service M/W")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Service M/W field.';

                }
                field("Availlable Accomodation"; Rec."Availlable Accomodation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Availlable Accomodation field.';

                }
                field("Service Region"; Rec."Service Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Region field.';

                }
                field("Service Unit"; Rec."Service Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Unit field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Requested Start Date"; Rec."Requested Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested Start Date field.';

                }
                field("Expected Date"; Rec."Expected Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expected Date field.';
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Arrival Date field.';
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = basic;
                Image = Allocate;
                Caption = 'Confirmation Lines';
                RunObject = page "Deployment Confirmation Lines";
                RunPageLink = "Deployment No" = field(No);
                ToolTip = 'Executes the Confirmation Lines action.';
            }
        }
    }
}