Report 50196 "Biometric Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BiometricEntries.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Biometrics Entries"; "Biometrics Entries")
        {
            RequestFilterFields = "Machine No", CheckTime;
            column(ReportForNavId_1; 1) { }
            column(LineNo_BiometricsEntries; "Biometrics Entries"."Line No") { }
            column(UserNo_BiometricsEntries; "Biometrics Entries"."User No") { }
            column(SSN_BiometricsEntries; "Biometrics Entries".SSN) { }
            column(Name_BiometricsEntries; "Biometrics Entries".Name) { }
            column(CheckTime_BiometricsEntries; "Biometrics Entries".CheckTime) { }
            column(Type_BiometricsEntries; "Biometrics Entries".Type) { }
            column(StudentNo_BiometricsEntries; "Biometrics Entries"."Student No") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

