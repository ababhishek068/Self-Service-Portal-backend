page 50260 "Deployment Allocation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Deployment Request";
    CardPageId = "Deployment Allocations";
    SourceTableView = where("Document Level" = filter(Allocation), "Project Status" = filter(Active));
    Editable = false;
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
                field("Project End Date"; Rec."Project End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Project End Date field.';
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
                Caption = 'Allocation Lines';
                RunObject = page "Deployment Lines";
                RunPageLink = "Deployment No" = field(No);
                ToolTip = 'Executes the Allocation Lines action.';
            }
        }
    }
}