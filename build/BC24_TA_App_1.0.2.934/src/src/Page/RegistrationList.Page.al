page 51345 "Registration List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Registration Form";
    CardPageId = "Registration Card";
    SourceTableView = where(Status = filter(Pending));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No field.';

                }
                field("Full Names"; Rec."Full Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Names field.';

                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';

                }
                field("Training College"; Rec."Training College")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Training College field.';

                }
                field(Brigade; Rec.Brigade)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Brigade field.';

                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Region field.';

                }
                field(Tribe; Rec.Tribe)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tribe field.';

                }
                field("Mean Grade"; Rec."Mean Grade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mean Grade field.';

                }
                field("Letter No"; Rec."Letter No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Letter No field.';

                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';

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
                ApplicationArea = All;
                Visible = false;
                Image = Register;
                Caption = 'Admit as Student';
                ToolTip = 'Executes the Admit as Student action.';
                trigger OnAction();
                var
                    Cust: record customer;
                begin
                    if confirm('Do you really want to admit the student?', false) then begin
                        if not Cust.get(Rec."Serial No") then begin
                            Cust.init;
                            Cust."No." := Rec."Serial No";
                            Cust.Name := Rec."Full Names";
                            Cust.Gender := Rec.Gender;
                            Cust."Customer Type" := Cust."Customer Type"::Student;
                            Cust."Customer Posting Group" := 'STUDENT';
                            //Cust.Region := Rec.Region;
                            Cust.Address := Rec."Nearest Town";
                            Cust."ID No" := Rec."ID Number";
                            Cust.Disabled := Rec."Is Disable";
                            Cust.Image := Rec."Applicant Photo";
                            Cust.insert;
                        end;
                    end;
                end;
            }
        }
    }
}