Page 51210 "Company Activities"
{
    PageType = List;
    SourceTable = "Company Activities";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Day; Rec.Day)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day field.';
                }
                field(Venue; Rec.Venue)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Venue field.';
                }
                field(Attachement; Rec.Attachement)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attachement field.';
                }
                field(Responsibility; Rec.Responsibility)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility field.';
                }
                field(Costs; Rec.Costs)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Costs field.';
                }
                field(Control1000000022; Rec.Post)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(Name; Rec."First Name" + '  ' + Rec."Middle Name" + '  ' + Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(Attachments; Rec.Attachments)
                {
                    ApplicationArea = Basic;
                    Lookup = true;
                    ToolTip = 'Specifies the value of the Attachments field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Participants)
            {
                Caption = 'Participants';
                action(Employees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees';
                    RunObject = Page "Activity Employess";
                    ToolTip = 'Executes the Employees action.';
                }
            }
            group(Attachment)
            {
                Caption = '&Attachment';
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    ShortCutKey = 'Return';
                    ToolTip = 'Executes the Open action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then
                            InteractTemplLanguage.OpenAttachment;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;
                    ToolTip = 'Executes the Create action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Rec.Code;
                            InteractTemplLanguage."Language Code" := Rec."Language Code (Default)";
                            InteractTemplLanguage.Description := Rec.Description;
                        end;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.Update;
                        Rec.Attachement := Rec.Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Copyfrom)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &from';
                    Ellipsis = true;
                    ToolTip = 'Executes the Copy &from action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Rec.Code;
                            InteractTemplLanguage."Language Code" := Rec."Language Code (Default)";
                            InteractTemplLanguage.Description := Rec.Description;
                            InteractTemplLanguage.Insert;
                            Commit;
                        end;
                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.Update;
                        Rec.Attachement := Rec.Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    ToolTip = 'Executes the Import action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Rec.Code;
                            InteractTemplLanguage."Language Code" := Rec."Language Code (Default)";
                            InteractTemplLanguage.Description := Rec.Description;
                            InteractTemplLanguage.Insert;
                        end;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.Update;
                        Rec.Attachement := Rec.Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Export)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    ToolTip = 'Executes the E&xport action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then
                            InteractTemplLanguage.ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;
                    ToolTip = 'Executes the Remove action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.RemoveAttachment(true);
                            Rec.Attachement := Rec.Attachement::No;
                            Rec.Modify;
                        end;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    GenJournal.Reset;
                    GenJournal.SetRange(GenJournal."Journal Template Name", 'GENERAL');
                    GenJournal.SetRange(GenJournal."Journal Batch Name", 'COMP ACT.');
                    GenJournal.DeleteAll;

                    CompanyAct.Reset;
                    CompanyAct.SetRange(CompanyAct.Post, true);
                    CompanyAct.SetRange(CompanyAct.Posted, false);

                    if CompanyAct.Find('-') then begin
                        PostingGroups.Reset;
                        if PostingGroups.Find('-') then begin

                            repeat
                                GenJournal.Init;
                                GenJournal."Journal Template Name" := 'GENERAL';
                                GenJournal."Journal Batch Name" := 'COMP ACT.';
                                GenJournal."Line No." := GenJournal."Line No." + LineNo;
                                GenJournal."Account Type" := GenJournal."account type"::"G/L Account";
                                GenJournal."Account No." := PostingGroups."Comp. Act. Debit Account";
                                GenJournal."Posting Date" := WorkDate;
                                GenJournal."Document No." := CompanyAct.Code + '-' + Format(CompanyAct.Day);
                                GenJournal."Bal. Account Type" := GenJournal."account type"::"Bank Account";
                                GenJournal."Bal. Account No." := PostingGroups."Comp. Act. Credit Account";
                                GenJournal.Description := CompanyAct.Description + '-' + Format(CompanyAct.Day);
                                GenJournal.Amount := CompanyAct.Costs;
                                GenJournal.Validate(GenJournal.Amount);
                                GenJournal.Insert;

                                CompanyAct.Posted := true;
                                CompanyAct.Modify;
                                LineNo := LineNo + 10000;
                            until CompanyAct.Next = 0;
                        end;
                    end;

                    GenJournal.Reset;
                    GenJournal.SetRange(GenJournal."Journal Template Name", 'GENERAL');
                    GenJournal.SetRange(GenJournal."Journal Batch Name", 'COMP ACT.');
                    if GenJournal.Find('-') then
                        Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournal);

                    //MESSAGE('%1','Posting Completed Successfully');
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                var
                    CompActivities: Record "Company Activities";
                    CompActivitiesReport: Report "Staff Welfare";
                begin
                    CompActivities.Reset();
                    if CompActivities.Find('-') then begin
                        CompActivitiesReport.SetTableView(CompActivities);
                        CompActivitiesReport.Run();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Validate(Responsibility);
    end;

    var
        GenJournal: Record "Gen. Journal Line";
        LineNo: Integer;
        CompanyAct: Record "Company Activities";
        PostingGroups: Record "HR Posting Groups";
}

