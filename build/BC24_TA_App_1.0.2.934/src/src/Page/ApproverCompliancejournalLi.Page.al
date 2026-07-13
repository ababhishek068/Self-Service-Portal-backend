Page 50672 "Approver Compliance journal Li"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Compliance journal";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(GrantNo; Rec."Grant No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grant No field.';
                }
                field(ComplianceCode; Rec."Compliance Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Compliance Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(DocumentNo; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(Complied; Rec.Complied)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Complied field.';

                    trigger OnValidate()
                    begin
                        Commit;
                    end;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostComplianceReport)
            {
                ApplicationArea = Basic;
                Caption = 'Post Compliance Report';
                ToolTip = 'Executes the Post Compliance Report action.';

                trigger OnAction()
                begin
                    objcomplianceJournalCheck.Reset;
                    objcomplianceJournalCheck.SetRange(objcomplianceJournalCheck."Grant No", Rec."Grant No");
                    //objcomplianceJournalCheck.SETRANGE(objcomplianceJournalCheck."Compliance Code","Compliance Code");
                    objcomplianceJournalCheck.SetRange(objcomplianceJournalCheck."Document No", Rec."Document No");
                    objcomplianceJournalCheck.SetRange(objcomplianceJournalCheck.Complied, false);
                    if objcomplianceJournalCheck.Find('-') then Error('One or more compliance not yet');

                    if Confirm('Are you sure you want to post the compliance report') then begin

                        //Insert sasa--------------------------------------------------------------------------------------
                        objcomplianceJournal.Reset;
                        objcomplianceJournal.SetRange(objcomplianceJournal."Grant No", Rec."Grant No");
                        objcomplianceJournal.SetRange(objcomplianceJournal."Document No", Rec."Document No");
                        if objCompliance.Find('-') then
                            repeat
                                if objcomplianceJournal."Grant No" <> '' then begin   //Becoz of the error
                                    objCompLedgerEntriesCheck.Reset;  //Grant No,Compliance Code,Document No
                                    objCompLedgerEntriesCheck.SetRange(objCompLedgerEntriesCheck."Grant No", objcomplianceJournal."Grant No");
                                    objCompLedgerEntriesCheck.SetRange(objCompLedgerEntriesCheck."Compliance Code", objcomplianceJournal."Compliance Code");
                                    objCompLedgerEntriesCheck.SetRange(objCompLedgerEntriesCheck."Document No", objcomplianceJournal."Document No");
                                    if objCompLedgerEntriesCheck.Find('-') then begin
                                        objCompLedgerEntries."Grant No" := objcomplianceJournal."Grant No";
                                        objCompLedgerEntries."Compliance Code" := objcomplianceJournal."Compliance Code";
                                        objCompLedgerEntries.Description := objcomplianceJournal.Description;
                                        objCompLedgerEntries."Document No" := objcomplianceJournal."Document No";
                                        objCompLedgerEntries."Document Date" := objcomplianceJournal."Document Date";
                                        objCompLedgerEntries.User := UserId;
                                        objCompLedgerEntries.Amount := objcomplianceJournal.Amount;
                                        objCompLedgerEntries.Comments := objcomplianceJournal.Comments;
                                        objCompLedgerEntries.Modify;
                                    end else begin
                                        objCompLedgerEntries.Init;
                                        objCompLedgerEntries."Grant No" := objcomplianceJournal."Grant No";
                                        objCompLedgerEntries."Compliance Code" := objcomplianceJournal."Compliance Code";
                                        objCompLedgerEntries.Description := objcomplianceJournal.Description;
                                        objCompLedgerEntries."Document No" := objcomplianceJournal."Document No";
                                        objCompLedgerEntries."Document Date" := objcomplianceJournal."Document Date";
                                        objCompLedgerEntries.User := UserId;
                                        objCompLedgerEntries.Amount := objcomplianceJournal.Amount;
                                        objCompLedgerEntries.Comments := objcomplianceJournal.Comments;
                                        objCompLedgerEntries.Insert;
                                    end;
                                end;
                            until objcomplianceJournal.Next = 0;
                    end;

                    //Delete journal entries--------------------------------------------------------------------------
                    objcomplianceJournal.Reset;
                    objcomplianceJournal.SetRange(objcomplianceJournal."Grant No", Rec."Grant No");
                    objcomplianceJournal.SetRange(objcomplianceJournal."Document No", Rec."Document No");
                    objcomplianceJournal.SetRange(objcomplianceJournal.Complied, true);
                    if objcomplianceJournal.Find('-') then objcomplianceJournal.DeleteAll;

                    Message('Compliance Successfully updated');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*IF UserMgt.GetPurchasesFilter1() <> '' THEN BEGIN
          FILTERGROUP(2);
          SETFILTER("Grant No",UserMgt.GetPurchasesFilter1());
          FILTERGROUP(0);
        END
        ELSE
        SETFILTER("Grant No",'%1',UserMgt.GetPurchasesFilter1());
         */

    end;

    var
        objCompliance: Record "Grants Compliance";
        objCompLedgerEntries: Record "Compliance ledger Entries";
        objCompLedgerEntriesCheck: Record "Compliance ledger Entries";
        objcomplianceJournal: Record "Compliance journal";
        objcomplianceJournalCheck: Record "Compliance journal";
    //  UserMgt: Codeunit UnknownCodeunit70134711;
}

