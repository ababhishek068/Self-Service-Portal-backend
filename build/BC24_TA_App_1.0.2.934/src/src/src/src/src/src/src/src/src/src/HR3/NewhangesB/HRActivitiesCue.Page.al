page 51283 "HR Activities Cue"
{
    PageType = CardPart;
    SourceTable = "HR Activities Cue";
    ApplicationArea = All;


    layout
    {
        area(content)
        {

            cuegroup(JobsActivities)
            {
                Caption = 'Jobs Dashboard';
                ShowCaption = true;
                Visible = true;
                field("All Jobs"; Rec."All Jobs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the All Jobs field.';

                }
            }
            cuegroup(DueEmployeesGroup)
            {
                Caption = 'Staff Dashboard';
                ShowCaption = true;
                Visible = true;


                field("Staff on Leave"; Rec."Staff on Leave")
                {
                    ApplicationArea = All;
                    Caption = 'Staff On Leave';
                    ToolTip = 'Specifies the value of the Staff On Leave field.';
                }

                field("Contracts Due"; Rec."Contracts Due")
                {
                    ApplicationArea = All;
                    Caption = 'Contracts Due';
                    ToolTip = 'Specifies the value of the Contracts Due field.';
                }

                field("Retirement Report"; Rec."Retirement Report")
                {
                    ApplicationArea = all;
                    Caption = 'Retirement';
                    ToolTip = 'Specifies the value of the Retirement field.';
                }

                field("Probation Report"; Rec."Probation Report")
                {
                    ApplicationArea = all;
                    Caption = 'Probation Report';
                    ToolTip = 'Specifies the value of the Probation Report field.';
                }
            }


            cuegroup(EmployeeActivitiesActive)
            {
                Caption = 'Employee Dashboard';
                ShowCaption = true;
                Visible = true;
                field("Active Employees"; Rec."Active Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Active Employees';
                    ToolTip = 'Specifies the value of the Active Employees field.';
                }
                field("In-Active Employees"; Rec."In-Active Employees")
                {
                    ApplicationArea = All;
                    Caption = 'In-Active Employees';
                    ToolTip = 'Specifies the value of the In-Active Employees field.';
                }
                field("Contract Staff"; Rec."Contract Staff")
                {
                    ApplicationArea = all;
                    Caption = 'Contract Staff';
                    ToolTip = 'Specifies the value of the Contract Staff field.';
                }

                field("Permanent Staff"; Rec."Permanent Staff")
                {
                    ApplicationArea = all;
                    Caption = 'Permanent Staff';
                    ToolTip = 'Specifies the value of the Permanent Staff field.';
                }
                field("Seconded Staff"; Rec."Seconded Staff")
                {
                    Caption = 'Seconded Staff';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seconded Staff field.';
                }
            }


            cuegroup(EmployeeActivitiesGender)
            {
                Caption = 'Gender Dashboard';
                ShowCaption = false;
                Visible = true;


                field("Male Employees"; Rec."Male Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Male Employees';
                    ToolTip = 'Specifies the value of the Male Employees field.';
                }

                field("Female Employees"; Rec."Female Employees")
                {
                    ApplicationArea = All;
                    Caption = 'Female Employees';
                    ToolTip = 'Specifies the value of the Female Employees field.';
                }
            }
        }

    }



    trigger OnOpenPage();
    begin

        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;
}




