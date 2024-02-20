namespace Cardano.Devnet.Models;

public record CardanoTip
{
    public int Block { get; init; }
    public int Epoch { get; init; }
    public string Era { get; init; } = default!;
    public string Hash { get; init; } = default!;
    public int Slot { get; init; }
    public int SlotInEpoch { get; init; }
    public int SlotsToEpochEnd { get; init; }
    public string SyncProgress { get; init; } = default!;
}