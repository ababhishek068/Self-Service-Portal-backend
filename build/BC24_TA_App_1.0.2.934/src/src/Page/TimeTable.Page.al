Page 51130 "Time Table"
{
    PageType = ListPlus;
    SourceTable = "Units/Subjects";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CampusFilter; CampusFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Campus Filter';
                    ToolTip = 'Specifies the value of the Campus Filter field.';
                }
                field(ProgFilter; ProgFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme Filter';
                    Lookup = true;
                    // LookupPageID = "Programmes List";
                    TableRelation = Programme.Code;
                    ToolTip = 'Specifies the value of the Programme Filter field.';

                    trigger OnValidate()
                    begin
                        Rec.SetFilter("Programme Code", ProgFilter);
                    end;
                }
                field(StageFilter; StageFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stage Filter';
                    Lookup = true;
                    TableRelation = "Programme Stages".Code;
                    ToolTip = 'Specifies the value of the Stage Filter field.';
                }
                field(SemFilter; SemFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester Filter';
                    Lookup = true;
                    TableRelation = Semesters.Code;
                    ToolTip = 'Specifies the value of the Semester Filter field.';
                }
                field(DayFilter; DayFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Day Filter';
                    Lookup = true;
                    TableRelation = "Day Of Week".Day;
                    ToolTip = 'Specifies the value of the Day Filter field.';
                }
                field(RoomFilter; RoomFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Room Filter';
                    TableRelation = "Lecture Rooms".Code;
                    ToolTip = 'Specifies the value of the Room Filter field.';
                }
                field(LecFilter; LecFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lecturer Filter';
                    TableRelation = "HR-Employee"."No." where(Lecturer = const(True));
                    ToolTip = 'Specifies the value of the Lecturer Filter field.';
                }
            }
            //part(MatrixForm; UnknownPage39006173)
            //   {
            //   }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ImportTT)
            {
                Caption = 'Import Time Table';
                ApplicationArea = basic;
                Promoted = true;
                Image = Import;
                RunObject = xmlport "Import Time Table";
                ToolTip = 'Executes the Import Time Table action.';
            }
        }
    }

    var
        ProgFilter: Code[20];
        StageFilter: Code[20];
        SemFilter: Code[20];
        DayFilter: Code[20];
        RoomFilter: Code[20];
        LecFilter: Code[20];
        CampusFilter: Code[20];
}

