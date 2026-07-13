TableExtension 50009 tableextension70134678 extends "G/L Entry"
{
    fields
    {

        field(39003900; Paid; Boolean)
        {

            trigger OnValidate()
            begin
                //Update the sales invoice------
                objSalesLine.Reset;
                //objSalesLine.SETRANGE(objSalesLine."No.","G/L Account No.");
                objSalesLine.SetRange(objSalesLine."Document No.", "Sales Line No.");
                objSalesLine.SetRange(objSalesLine."Line No.", "Sales Line Line No.");
                if objSalesLine.Find('-') then begin
                    if Paid = true then begin
                        objSalesLine.Quantity := 1;
                        objSalesLine."Unit Price" := objSalesLine."Unit Price" + Amount;
                        objSalesLine.Modify;
                    end else begin
                        objSalesLine."Unit Price" := objSalesLine."Unit Price" - Amount;
                        objSalesLine.Modify;

                    end;
                end;
            end;
        }
        field(39003901; "Sales Line No."; Code[20]) { }
        field(39003902; "Sales Line Line No."; Integer) { }
        field(39003903; "Customer No"; Code[20])
        {
            CalcFormula = lookup("Cust. Ledger Entry"."Customer No." where("Document No." = field("Document No."),
                                                                            "Transaction No." = field("Transaction No.")));
            FieldClass = FlowField;
        }
        field(39003904; "School Code"; Code[20])
        {
            CalcFormula = lookup("Dimension Value"."School Code" where(Code = field("Global Dimension 2 Code"),
                                                                        "Global Dimension No." = const(2)));
            FieldClass = FlowField;
        }

        field(39003906; "Vendor No"; Code[20])
        {
            CalcFormula = lookup("Vendor Ledger Entry"."Vendor No." where("Document No." = field("Document No."),
                                                                           "Transaction No." = field("Transaction No.")));
            FieldClass = FlowField;
        }
        field(39003907; "Bank No"; Code[20])
        {
            CalcFormula = lookup("Bank Account Ledger Entry"."Bank Account No." where("Document No." = field("Document No."),
                                                                                       "Transaction No." = field("Transaction No.")));
            FieldClass = FlowField;
        }
        field(39003908; "Asset No"; Code[20])
        {
            CalcFormula = lookup("FA Ledger Entry"."FA No." where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(39003909; "Exist in Cust"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Document No." = field("Document No."),
                                                            "Posting Date" = field("Posting Date"),
                                                            "Customer Posting Group" = filter('IMPREST')));
            FieldClass = FlowField;
        }
        field(39003910; "Vessel No"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Vessel No" where("No." = field("Document No.")));
            FieldClass = FlowField;
        }

        field(50010; "Applied Document No"; Code[50])
        {
            CalcFormula = lookup("Payments Application Lines".No where("Document No" = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50011; "Applied Cheque No"; Code[50])
        {
            CalcFormula = lookup("Payments Header"."Cheque No." where("No." = field("Applied Document No")));
            FieldClass = FlowField;
        }
        field(50012; "Transaction No. Modified"; Boolean) { }
    }
    keys
    {

        //Unsupported feature: Property Modification (SumIndexFields) on ""G/L Account No.","Posting Date"(Key)".


        //Unsupported feature: Property Modification (SumIndexFields) on ""G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date"(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""Gen. Bus. Posting Group","Gen. Prod. Posting Group"(Key)".


        //Unsupported feature: Deletion (KeyCollection) on ""VAT Bus. Posting Group","VAT Prod. Posting Group"(Key)".

    }

    //Unsupported feature: Property Modification (Attributes) on "OnAfterCopyGLEntryFromGenJnlLine(PROCEDURE 6)".


    //Unsupported feature: Property Deletion (Attributes) on "UpdateAccountID(PROCEDURE 1166)".


    //Unsupported feature: Property Modification (Subtype) on "CopyFromDeferralPostBuffer(PROCEDURE 46).DeferralPostBuffer(Parameter 1001)".


    var
        objSalesLine: Record "Sales Line";
}

