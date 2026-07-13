Page 50074 "Graduating Students"
{
    Editable = false;
    PageType = List;
    SourceTable = "Graduating Students";
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
                field(Names; Rec.Names)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Option; Rec.Option)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Option field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(CurrentAv; Rec."Current Av")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Av field.';
                }
                field(CummAv; Rec."Cumm Av")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cumm Av field.';
                }
                field(Award; Rec.Award)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Award field.';
                }
                field(School; Rec.School)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the School field.';
                }
                field(ProgName; Rec."Prog Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prog Name field.';
                }
                field(ProgCount; Rec."Prog Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prog Count field.';
                }
                field(SchoolCode; Rec."School Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the School Code field.';
                }
                field(TotalCFTaken; Rec."Total CF Taken")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total CF Taken field.';
                }
                field(ExistinCurrSem; Rec."Exist in Curr Sem")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exist in Curr Sem field.';
                }
                field(GraduationYear; Rec."Graduation Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Graduation Year field.';
                }
                field(ExistsInGraduated; Rec."Exists In Graduated")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exists In Graduated field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(OnlineAppliedCount; Rec."Online Applied Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Online Applied Count field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Update Student")
            {
                ApplicationArea = Basic;
                Image = UpdateUnitCost;
                ToolTip = 'Executes the Update Student action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Update the student results?', false) then begin
                        GradRec.Reset;
                        GradRec.SetFilter(No, Rec.No);
                        if GradRec.Find('-') then
                            Report.Run(70134798, false, false, GradRec);
                    end;
                end;
            }
        }
    }

    var
        GradRec: Record "Graduating Students";
}

