Report 50257 "HMS Nurse Notes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSNurseNotes.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Admission Form Nurse"; "HMS Admission Form Nurse")
        {
            DataItemTableView = sorting("Notes Date", "Notes Time") order(ascending);
            column(ReportForNavId_1; 1) { }
            column(NurseID_HMSAdmissionFormNurse; UserRec.UserName) { }
            column(NotesDate_HMSAdmissionFormNurse; NotesDate) { }
            column(NotesTime_HMSAdmissionFormNurse; NotesTime) { }
            column(Notes_HMSAdmissionFormNurse; "HMS Admission Form Nurse".Notes) { }
            column(PatNo; HMSPatient."Patient No.") { }
            column(DateReg; HMSPatient."Date Registered") { }
            column(PatNames; HMSPatient.Surname + ' ' + HMSPatient."Middle Name" + ' ' + HMSPatient."Last Name") { }
            column(LogoName; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(CompInfAddress; CompInf.Address) { }
            column(CompInfAddress2; CompInf."Address 2") { }
            column(CompInfPhone; CompInf."Phone No.") { }
            column(Gender; HMSPatient.Gender) { }
            column(AdmNo; HMSPatient."Employee No.") { }
            column(Ward; HMSPatient.Nationality) { }

            trigger OnAfterGetRecord()
            begin
                NotesTime := Format("HMS Admission Form Nurse"."Notes Time");
                NotesDate := Format("HMS Admission Form Nurse"."Notes Date");

                HMSPatient.Reset;
                HMSPatient.SetRange(HMSPatient."Adm No.", "Admission No.");
                if HMSPatient.Find('-') then begin

                end;

                if UserRec.Get("HMS Admission Form Nurse"."Nurse ID") then;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        NotesTime: Text;
        NotesDate: Text;
        HMSPatient: Record "HMS Patient";
        CompInf: Record "Company Information";
        UserRec: Record "User Setup";
}

