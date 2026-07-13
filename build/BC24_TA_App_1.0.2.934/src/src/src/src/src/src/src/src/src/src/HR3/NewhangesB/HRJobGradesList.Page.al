Page 51101 "HR Job Grades List"
{
    CardPageID = "HR Job Grades Card";
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "HR Job Grades";
    //[<SORTING>[<KeyList>] [ORDER(Ascending|Descending)] [WHERE(<TableFilters>)]
    SourceTableView = sorting("Sorting Oder") order(descending);
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Descrition; Rec.Descrition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Descrition field.';
                }

                field("Sorting Oder"; Rec."Sorting Oder")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sorting Oder field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000005; Notes) { }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(CreateJobGrade)
            {
                Caption = 'Create Job Grades';
                ApplicationArea = all;
                ToolTip = 'Executes the Create Job Grades action.';
                trigger OnAction()
                var
                    HRJobGrades: Record "HR Job Grades";
                    i: Integer;
                    NoOfGrades: Integer;
                begin
                    NoOfGrades := 10;
                    HRJobGrades.DeleteAll();


                    for i := 1 to NoOfGrades do begin
                        HRJobGrades.Init();
                        HRJobGrades.Code := 'BRS-0' + Format(i);
                        HRJobGrades.Descrition := HRJobGrades.Code;
                        HRJobGrades."Sorting Oder" := i;

                        HRJobGrades.Insert();
                    end;
                    Message('Grades Created Succssfully');

                end;
            }
        }
    }
}

