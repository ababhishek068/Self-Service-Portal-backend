page 51443 "Tender Passwords Page"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Tender Committee";
    Caption = 'Committee Passwords Page';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Designation; Rec.Designation)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field(User; Rec.User)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the User field.';
                }
                field(Password; Password1)
                {
                    ExtendedDatatype = Masked;
                    HideValue = true;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Password1 field.';
                }
                field("Repeat Password"; Password2)
                {
                    ExtendedDatatype = Masked;
                    HideValue = true;
                    ToolTip = 'Specifies the value of the Password2 field.';

                    trigger OnValidate()
                    begin
                        IF Password1 <> Password2 THEN ERROR('Passwords for User ' + Rec.User + ' do not match.');
                        IF Password1 <> Rec.UserPassword THEN ERROR('You keyed in a wrong password');

                        IF (Password1 = Password2) AND (Password1 = Rec.UserPassword) THEN Rec.Authenticated := TRUE;
                    end;
                }
                field(Authenticated; Rec.Authenticated)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Authenticated field.';
                }
                field("Authenticated Count"; Rec."Authenticated Count")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Authenticated Count field.';
                }
            }
        }
    }

    actions { }

    trigger OnClosePage()
    var
        BidAnalysis: Record "Bid Analysis";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLines: Record "Purchase Line";
        InsertCount: Integer;
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        Checkifallauthenticated := FALSE;
        Committee.RESET;
        Committee.SETRANGE(Committee."Tendor No", Rec."Tendor No");
        Committee.SETRANGE(Committee."Committee Type", Rec."Committee Type");
        IF Committee.FIND('-') THEN BEGIN
            REPEAT
                Committee.CALCFIELDS("Authenticated Count");
                PurchSetup.Get();
                IF Committee."Authenticated Count" > PurchSetup."RFQ Committee Members Limit" THEN BEGIN
                    Checkifallauthenticated := TRUE;
                END ELSE BEGIN
                    IF Rec.Authenticated = FALSE THEN ERROR('User ' + Rec.User + ' is not authenticated.') ELSE Checkifallauthenticated := TRUE;
                END;
            UNTIL Committee.NEXT = 0;
        END;
        IF (Checkifallauthenticated = TRUE) and (Rec."Committee Type" <> Rec."Committee Type"::"Contract Implementation Team") THEN BEGIN
            TenderBids.RESET;
            TenderBids.SETFILTER(TenderBids."RFQ No.", Rec."Tendor No");
            IF TenderBids.FIND('-') THEN
                /*BidAnalysis.SETRANGE(BidAnalysis."RFQ No.","Tendor No");
              BidAnalysis.DELETEALL;*/


                //insert the quotes from vendors
                PurchaseHeader.RESET;
            PurchaseHeader.SETRANGE(PurchaseHeader."RFQ No.", Rec."Tendor No");
            IF PurchaseHeader.FINDSET THEN
                REPEAT
                    PurchaseLines.RESET;
                    PurchaseLines.SETRANGE("Document No.", PurchaseHeader."No.");
                    IF PurchaseLines.FINDSET THEN
                        REPEAT
                            BidAnalysis.RESET;
                            BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Tendor No");
                            BidAnalysis.SETRANGE(BidAnalysis."Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                            BidAnalysis.SETRANGE(BidAnalysis."Item No.", PurchaseLines."No.");
                            BidAnalysis.SETRANGE(BidAnalysis."Quote No.", PurchaseLines."Document No.");
                            IF NOT BidAnalysis.FIND('-') THEN BEGIN
                                BidAnalysis.INIT;
                                BidAnalysis."RFQ No." := Rec."Tendor No";
                                BidAnalysis."RFQ Line No." := PurchaseLines."Line No.";
                                BidAnalysis."Quote No." := PurchaseLines."Document No.";
                                BidAnalysis."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                                BidAnalysis."Item No." := PurchaseLines."No.";
                                BidAnalysis.Description := PurchaseLines.Description;
                                BidAnalysis.Quantity := PurchaseLines.Quantity;
                                BidAnalysis."Unit Of Measure" := PurchaseLines."Unit of Measure";
                                BidAnalysis.Amount := PurchaseLines."Direct Unit Cost";
                                BidAnalysis."Line Amount" := BidAnalysis.Quantity * BidAnalysis.Amount;
                                BidAnalysis.Select := FALSE;
                                BidAnalysis.INSERT(TRUE);
                                InsertCount += 1;
                            END;
                        UNTIL PurchaseLines.NEXT = 0;
                UNTIL PurchaseHeader.NEXT = 0;
            BidAnalysis.RESET;
            BidAnalysis.SETRANGE(BidAnalysis."RFQ No.", Rec."Tendor No");
            IF BidAnalysis.FIND('-') THEN BidAnalysis.MODIFYALL(Select, FALSE);
            IF Committee."Committee Type" = Committee."Committee Type"::"RFQ Evaluation Committee" THEN BEGIN
                PAGE.RUN(PAGE::"Bid Analysis", TenderBids);
            END;
            IF Committee."Committee Type" = Committee."Committee Type"::"RFQ Opening Committee" THEN BEGIN
                PAGE.RUN(Page::"Bid Analysis1", TenderBids);
            END;
        END;
        IF (Checkifallauthenticated = TRUE) and (Rec."Committee Type" = Rec."Committee Type"::"Contract Implementation Team") THEN BEGIN
            Milestones.Reset();
            Milestones.SetRange("Contract No", Rec."Tendor No");
            Milestones.SetFilter("Milestone Status", '<>%1', Milestones."Milestone Status"::Completed);
            if Milestones.FindFirst() then begin
                Milestones."Milestone Status" := Milestones."Milestone Status"::Completed;
                Milestones.Modify();
                CurrPage.Close();
            end;
        end;

    end;

    trigger OnOpenPage()
    begin
        Password1 := '';
        Password2 := '';
        Committee.RESET;
        Committee.SETRANGE(Committee."Tendor No", Rec."Tendor No");
        IF Committee.FIND('-') THEN BEGIN
            REPEAT
                Committee.Authenticated := FALSE;
                Committee.MODIFY;
            UNTIL Committee.NEXT = 0;
        END;
    end;

    var
        Password1: Text;
        Password2: Text;
        Committee: Record "Tender Committee";
        TenderBids: Record "Bid Analysis";
        Checkifallauthenticated: Boolean;
        Milestones: Record "Contract Milestones";
}

