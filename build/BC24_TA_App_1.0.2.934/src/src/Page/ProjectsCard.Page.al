Page 50349 "Projects Card"
{
    PageType = Card;
    SourceTable = Projects;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Project Status Summary"; Rec."Project Status Summary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Status Summary field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProjectModules)
            {
                Caption = 'Project Modules';
                ApplicationArea = All;
                RunObject = page "Project Modules Allocations";
                RunPageLink = "Project No" = field(No);
                ToolTip = 'Executes the Project Modules action.';
            }
            action(ProjectTask)
            {
                Caption = 'Project Task';
                ApplicationArea = All;
                RunObject = page "Project Task";
                RunPageLink = "Project No" = field(No);
                ToolTip = 'Executes the Project Task action.';
            }
            action(ProjectSupportItems)
            {
                Caption = 'Project Support Items';
                ApplicationArea = All;
                RunObject = page "Project Support";
                RunPageLink = "Project No" = field(No);
                ToolTip = 'Executes the Project Support Items action.';
            }
            action(ProjectTeam)
            {
                Caption = 'Project Team';
                ApplicationArea = All;
                RunObject = page "Project Team";
                RunPageLink = "Project No" = field(No);
                ToolTip = 'Executes the Project Team action.';
            }
        }
    }
}

