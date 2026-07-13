Page 50380 "Online Results Release-Posted"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Online Results Release";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(ReleaseType; Rec."Release Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Release Type field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Reverse Online Results")
            {
                ApplicationArea = Basic;
                Image = ReleaseShipment;
                ToolTip = 'Executes the Reverse Online Results action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Undo the online results?', false) = false then Error('Aborted by User');


                    StudUnit.Reset;
                    StudUnit.SetRange(StudUnit.Released, true);
                    if Rec.Semester <> '' then
                        StudUnit.SETRANGE(StudUnit.Semester, Rec.Semester);
                    if Rec."Programme Code" <> '' then
                        StudUnit.SETRANGE(StudUnit.Programme, Rec."Programme Code");
                    if Rec.Stage <> '' then
                        StudUnit.SETRANGE(StudUnit.Stage, Rec.Stage);
                    if Rec."Programme Option" <> '' then
                        StudUnit.SETFILTER("Reg Option", Rec."Programme Option");
                    if Rec."Student No" <> '' then
                        StudUnit.SETFILTER("Student No.", Rec."Student No");

                    if StudUnit.Find('-') then begin
                        repeat
                            StudUnit.Released := false;
                            StudUnit."Release Code" := Rec.code;
                            StudUnit.modify;
                        until StudUnit.next = 0;
                    end;

                end;
            }


        }
    }

    var
        StudUnit: Record "Student Units";
}

