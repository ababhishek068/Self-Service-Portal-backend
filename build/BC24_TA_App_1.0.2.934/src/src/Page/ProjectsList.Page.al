Page 50350 "Projects List"
{
    CardPageID = "Projects Card";
    PageType = List;
    SourceTable = Projects;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Project Description"; Rec."Project Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Description field.';
                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer No field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Project Type"; Rec."Project Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Type field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Project Owner"; Rec."Project Owner")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Owner field.';
                }
            }
        }
    }

    actions { }
}

