-- CreateEnum
CREATE TYPE "rol_usuario" AS ENUM ('admin', 'tecnico', 'recepcionista');

-- CreateEnum
CREATE TYPE "prioridad_ticket" AS ENUM ('baja', 'media', 'alta', 'urgente');

-- CreateEnum
CREATE TYPE "estado_ticket" AS ENUM ('recibido', 'en_diagnostico', 'esperando_aprobacion', 'aprobado', 'esperando_refaccion', 'en_reparacion', 'listo_para_entrega', 'entregado', 'cancelado');

-- CreateEnum
CREATE TYPE "estado_pago" AS ENUM ('pendiente', 'parcial', 'pagado', 'reembolsado');

-- CreateEnum
CREATE TYPE "tipo_foto_ticket" AS ENUM ('ingreso', 'proceso', 'salida');

-- CreateEnum
CREATE TYPE "tipo_asignacion_ticket" AS ENUM ('principal', 'escalamiento', 'apoyo');

-- CreateEnum
CREATE TYPE "tipo_pago_ticket" AS ENUM ('anticipo', 'abono', 'liquidacion');

-- CreateEnum
CREATE TYPE "metodo_pago_ticket" AS ENUM ('efectivo', 'transferencia', 'tarjeta');

-- CreateTable
CREATE TABLE "usuarios" (
    "id_usuario" TEXT NOT NULL,
    "nombre_completo" TEXT NOT NULL,
    "correo" TEXT NOT NULL,
    "telefono" TEXT,
    "contrasena_hash" TEXT NOT NULL,
    "rol" "rol_usuario" NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id_usuario")
);

-- CreateTable
CREATE TABLE "clientes" (
    "id_cliente" TEXT NOT NULL,
    "nombre_completo" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "correo" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id_cliente")
);

-- CreateTable
CREATE TABLE "marcas" (
    "id_marca" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "marcas_pkey" PRIMARY KEY ("id_marca")
);

-- CreateTable
CREATE TABLE "modelos" (
    "id_modelo" TEXT NOT NULL,
    "id_marca" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "modelos_pkey" PRIMARY KEY ("id_modelo")
);

-- CreateTable
CREATE TABLE "dispositivos" (
    "id_dispositivo" TEXT NOT NULL,
    "id_cliente" TEXT NOT NULL,
    "id_modelo" TEXT NOT NULL,
    "imei" TEXT,
    "color" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "dispositivos_pkey" PRIMARY KEY ("id_dispositivo")
);

-- CreateTable
CREATE TABLE "tickets_reparacion" (
    "id_ticket" TEXT NOT NULL,
    "folio_ticket" TEXT NOT NULL,
    "id_dispositivo" TEXT NOT NULL,
    "id_usuario_creador" TEXT NOT NULL,
    "id_usuario_responsable_actual" TEXT,
    "falla_reportada" TEXT NOT NULL,
    "diagnostico_tecnico" TEXT,
    "prioridad" "prioridad_ticket" NOT NULL,
    "estado_actual" "estado_ticket" NOT NULL DEFAULT 'recibido',
    "estado_pago" "estado_pago" NOT NULL DEFAULT 'pendiente',
    "accesorios_recibidos" TEXT,
    "contrasena_dispositivo_cifrada" TEXT,
    "estado_fisico" TEXT,
    "fecha_recepcion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_estimada_entrega" TIMESTAMP(3),
    "fecha_entrega" TIMESTAMP(3),
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_actualizacion" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tickets_reparacion_pkey" PRIMARY KEY ("id_ticket")
);

-- CreateTable
CREATE TABLE "historial_estados_ticket" (
    "id_historial" TEXT NOT NULL,
    "id_ticket" TEXT NOT NULL,
    "estado" "estado_ticket" NOT NULL,
    "comentario" TEXT,
    "id_usuario_registro" TEXT,
    "fecha_registro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "historial_estados_ticket_pkey" PRIMARY KEY ("id_historial")
);

-- CreateTable
CREATE TABLE "presupuestos_reparacion" (
    "id_presupuesto" TEXT NOT NULL,
    "id_ticket" TEXT NOT NULL,
    "costo_mano_obra" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "costo_refacciones" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "costo_total" DECIMAL(10,2) NOT NULL,
    "dias_estimados" INTEGER,
    "aprobado_cliente" BOOLEAN,
    "fecha_aprobacion" TIMESTAMP(3),
    "id_usuario_creador" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "presupuestos_reparacion_pkey" PRIMARY KEY ("id_presupuesto")
);

-- CreateTable
CREATE TABLE "fotos_ticket" (
    "id_foto" TEXT NOT NULL,
    "id_ticket" TEXT NOT NULL,
    "url_foto" TEXT NOT NULL,
    "tipo_foto" "tipo_foto_ticket" NOT NULL,
    "id_usuario_subio" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "fotos_ticket_pkey" PRIMARY KEY ("id_foto")
);

-- CreateTable
CREATE TABLE "asignaciones_ticket" (
    "id_asignacion" TEXT NOT NULL,
    "id_ticket" TEXT NOT NULL,
    "id_usuario_tecnico" TEXT NOT NULL,
    "tipo_asignacion" "tipo_asignacion_ticket" NOT NULL,
    "motivo" TEXT,
    "fecha_asignacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "asignaciones_ticket_pkey" PRIMARY KEY ("id_asignacion")
);

-- CreateTable
CREATE TABLE "refacciones_ticket" (
    "id_refaccion_ticket" TEXT NOT NULL,
    "id_ticket" TEXT NOT NULL,
    "nombre_refaccion" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL DEFAULT 1,
    "costo_unitario" DECIMAL(10,2),
    "observaciones" TEXT,
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refacciones_ticket_pkey" PRIMARY KEY ("id_refaccion_ticket")
);

-- CreateTable
CREATE TABLE "pagos_ticket" (
    "id_pago" TEXT NOT NULL,
    "id_ticket" TEXT NOT NULL,
    "monto" DECIMAL(10,2) NOT NULL,
    "tipo_pago" "tipo_pago_ticket" NOT NULL,
    "metodo_pago" "metodo_pago_ticket" NOT NULL,
    "id_usuario_recibio" TEXT,
    "observaciones" TEXT,
    "fecha_pago" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pagos_ticket_pkey" PRIMARY KEY ("id_pago")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_correo_key" ON "usuarios"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "marcas_nombre_key" ON "marcas"("nombre");

-- CreateIndex
CREATE INDEX "modelos_id_marca_idx" ON "modelos"("id_marca");

-- CreateIndex
CREATE UNIQUE INDEX "modelos_id_marca_nombre_key" ON "modelos"("id_marca", "nombre");

-- CreateIndex
CREATE INDEX "dispositivos_id_cliente_idx" ON "dispositivos"("id_cliente");

-- CreateIndex
CREATE INDEX "dispositivos_id_modelo_idx" ON "dispositivos"("id_modelo");

-- CreateIndex
CREATE UNIQUE INDEX "tickets_reparacion_folio_ticket_key" ON "tickets_reparacion"("folio_ticket");

-- CreateIndex
CREATE INDEX "tickets_reparacion_id_dispositivo_idx" ON "tickets_reparacion"("id_dispositivo");

-- CreateIndex
CREATE INDEX "tickets_reparacion_id_usuario_creador_idx" ON "tickets_reparacion"("id_usuario_creador");

-- CreateIndex
CREATE INDEX "tickets_reparacion_id_usuario_responsable_actual_idx" ON "tickets_reparacion"("id_usuario_responsable_actual");

-- CreateIndex
CREATE INDEX "tickets_reparacion_folio_ticket_idx" ON "tickets_reparacion"("folio_ticket");

-- CreateIndex
CREATE INDEX "tickets_reparacion_estado_actual_idx" ON "tickets_reparacion"("estado_actual");

-- CreateIndex
CREATE INDEX "historial_estados_ticket_id_ticket_idx" ON "historial_estados_ticket"("id_ticket");

-- CreateIndex
CREATE INDEX "historial_estados_ticket_id_usuario_registro_idx" ON "historial_estados_ticket"("id_usuario_registro");

-- CreateIndex
CREATE UNIQUE INDEX "presupuestos_reparacion_id_ticket_key" ON "presupuestos_reparacion"("id_ticket");

-- CreateIndex
CREATE INDEX "presupuestos_reparacion_id_usuario_creador_idx" ON "presupuestos_reparacion"("id_usuario_creador");

-- CreateIndex
CREATE INDEX "fotos_ticket_id_ticket_idx" ON "fotos_ticket"("id_ticket");

-- CreateIndex
CREATE INDEX "fotos_ticket_id_usuario_subio_idx" ON "fotos_ticket"("id_usuario_subio");

-- CreateIndex
CREATE INDEX "asignaciones_ticket_id_ticket_idx" ON "asignaciones_ticket"("id_ticket");

-- CreateIndex
CREATE INDEX "asignaciones_ticket_id_usuario_tecnico_idx" ON "asignaciones_ticket"("id_usuario_tecnico");

-- CreateIndex
CREATE INDEX "refacciones_ticket_id_ticket_idx" ON "refacciones_ticket"("id_ticket");

-- CreateIndex
CREATE INDEX "pagos_ticket_id_ticket_idx" ON "pagos_ticket"("id_ticket");

-- CreateIndex
CREATE INDEX "pagos_ticket_id_usuario_recibio_idx" ON "pagos_ticket"("id_usuario_recibio");

-- AddForeignKey
ALTER TABLE "modelos" ADD CONSTRAINT "modelos_id_marca_fkey" FOREIGN KEY ("id_marca") REFERENCES "marcas"("id_marca") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_id_cliente_fkey" FOREIGN KEY ("id_cliente") REFERENCES "clientes"("id_cliente") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_id_modelo_fkey" FOREIGN KEY ("id_modelo") REFERENCES "modelos"("id_modelo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets_reparacion" ADD CONSTRAINT "tickets_reparacion_id_dispositivo_fkey" FOREIGN KEY ("id_dispositivo") REFERENCES "dispositivos"("id_dispositivo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets_reparacion" ADD CONSTRAINT "tickets_reparacion_id_usuario_creador_fkey" FOREIGN KEY ("id_usuario_creador") REFERENCES "usuarios"("id_usuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets_reparacion" ADD CONSTRAINT "tickets_reparacion_id_usuario_responsable_actual_fkey" FOREIGN KEY ("id_usuario_responsable_actual") REFERENCES "usuarios"("id_usuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historial_estados_ticket" ADD CONSTRAINT "historial_estados_ticket_id_ticket_fkey" FOREIGN KEY ("id_ticket") REFERENCES "tickets_reparacion"("id_ticket") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historial_estados_ticket" ADD CONSTRAINT "historial_estados_ticket_id_usuario_registro_fkey" FOREIGN KEY ("id_usuario_registro") REFERENCES "usuarios"("id_usuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "presupuestos_reparacion" ADD CONSTRAINT "presupuestos_reparacion_id_ticket_fkey" FOREIGN KEY ("id_ticket") REFERENCES "tickets_reparacion"("id_ticket") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "presupuestos_reparacion" ADD CONSTRAINT "presupuestos_reparacion_id_usuario_creador_fkey" FOREIGN KEY ("id_usuario_creador") REFERENCES "usuarios"("id_usuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotos_ticket" ADD CONSTRAINT "fotos_ticket_id_ticket_fkey" FOREIGN KEY ("id_ticket") REFERENCES "tickets_reparacion"("id_ticket") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotos_ticket" ADD CONSTRAINT "fotos_ticket_id_usuario_subio_fkey" FOREIGN KEY ("id_usuario_subio") REFERENCES "usuarios"("id_usuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "asignaciones_ticket" ADD CONSTRAINT "asignaciones_ticket_id_ticket_fkey" FOREIGN KEY ("id_ticket") REFERENCES "tickets_reparacion"("id_ticket") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "asignaciones_ticket" ADD CONSTRAINT "asignaciones_ticket_id_usuario_tecnico_fkey" FOREIGN KEY ("id_usuario_tecnico") REFERENCES "usuarios"("id_usuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refacciones_ticket" ADD CONSTRAINT "refacciones_ticket_id_ticket_fkey" FOREIGN KEY ("id_ticket") REFERENCES "tickets_reparacion"("id_ticket") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagos_ticket" ADD CONSTRAINT "pagos_ticket_id_ticket_fkey" FOREIGN KEY ("id_ticket") REFERENCES "tickets_reparacion"("id_ticket") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagos_ticket" ADD CONSTRAINT "pagos_ticket_id_usuario_recibio_fkey" FOREIGN KEY ("id_usuario_recibio") REFERENCES "usuarios"("id_usuario") ON DELETE SET NULL ON UPDATE CASCADE;
