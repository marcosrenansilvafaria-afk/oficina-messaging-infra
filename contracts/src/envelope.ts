/**
 * Envelope comum a todos os eventos do Saga publicados no topico SNS FIFO
 * "oficina-saga-events.fifo". `correlationId` deve ser o `ordemServicoId` -
 * e o identificador que amarra todos os eventos de uma mesma instancia do
 * Saga, permitindo rastrear o fluxo completo entre os 3 microsservicos.
 */
export interface SagaEventEnvelope<TPayload> {
  /** UUID v4 unico deste evento. Usado tambem como MessageDeduplicationId no SQS/SNS FIFO. */
  eventId: string;
  /** Nome do evento, igual ao MessageAttribute "eventType" usado nas filter policies do SNS. */
  eventType: string;
  /** Versao do schema do evento (semver simplificado, ex: "1.0"). */
  eventVersion: string;
  /** Timestamp ISO 8601 de quando o evento ocorreu (nao de quando foi publicado). */
  occurredAt: string;
  /** = ordemServicoId. Usado tambem como MessageGroupId no SNS/SQS FIFO (garante ordem por OS). */
  correlationId: string;
  /** Dados especificos do evento - ver os arquivos *.event.ts. */
  payload: TPayload;
}
